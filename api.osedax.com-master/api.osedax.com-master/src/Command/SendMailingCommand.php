<?php
// src/Command/SyncCurrencyCommand.php
namespace App\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Routing\RouterInterface;
use Symfony\Component\Routing\Generator\UrlGenerator;

use Doctrine\ORM\EntityManagerInterface;
use Twig\Environment;

use App\Entity\User;

class SendMailingCommand extends Command
{
    protected static $defaultName = 'app:send-mailing';
    private $em;
    private $mailer;
    private $twig;
    private $router;

    public function __construct(\Swift_Mailer $mailer, EntityManagerInterface $em, Environment $twig, RouterInterface $router)
    {

        $this->mailer = $mailer;
        $this->em = $em;
        $this->twig = $twig;
        $this->router = $router;

        parent::__construct();
    }

    protected function configure()
    {
        $this
            ->setDescription('Send mailing.')
            ->setHelp('This command sends mailing to all database')

        ;

    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
    
        set_time_limit(0);

        $repo = $this->em->getRepository(User::class);
        $users = $repo->findBy(['emailNotifications' => true, 'emailSentAt' => null]);

        $now = new \Datetime;

        $context = $this->router->getContext();
        $context->setHost('osedax-api.blkpos.com');
        $context->setScheme('https');
        $context->setBaseUrl('');


        $count = 0;
        foreach ($users as $user) {

            $count++;
            $output->writeln("Sending to: " . $user->getEmail());

             $message = (new \Swift_Message("Hay un nuevo capítulo disponible"))
                    ->setFrom("no-reply@osedax.app")
                    ->setTo( $user->getEmail() )
                    ->setBody(
                        $this->twig->render(
                            'emails/newsletter.html.twig',
                            [
                                "link" => $this->router->generate('app_api_applink', ['_format' => 'json'], UrlGenerator::ABSOLUTE_URL) ,
                                "link_remove" => $this->router->generate('app_api_newsletterremove', ['_format' => 'json', 'email' => $user->getEmail()], UrlGenerator::ABSOLUTE_URL) ,
                            ]
                        ),
                        'text/html'
                    )
                ;

                $this->mailer->send($message);

                $user->setEmailSentAt($now);
                $this->em->flush();

                if($count == 14){
                    sleep(1);
                    $count = 0;
                }

        }


            

        return 0;
    }
}