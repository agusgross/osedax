<?php
// Doxa/UserBundle/Controller/ApiController.php
 
namespace App\Controller;
 
use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\Controller\AbstractFOSRestController;
use FOS\RestBundle\Request\ParamFetcherInterface;
use FOS\RestBundle\Controller\Annotations\QueryParam;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Validator\ConstraintViolationListInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Validator\Constraints;
use Symfony\Contracts\Translation\TranslatorInterface;
use Symfony\Component\Routing\Generator\UrlGenerator;

use JMS\Serializer\SerializationContext;
use JMS\Serializer\SerializerInterface;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\ParamConverter;

use App\Entity\User;
use App\Helper\StringHelper;
use App\Entity\Chapter;
use App\Entity\Episode;
use App\Entity\Purchase;
use App\Entity\TextClipping;
use App\Entity\CharacterSelect;
use App\Entity\Bookmark;


class ApiController extends AbstractFOSRestController
{

    /**
     * @Rest\Post(
     *  "api/registration.{_format}"
     *)
     * @ParamConverter("user", converter="fos_rest.request_body")     
     */
    public function registrationAction(Request $request, ParamFetcherInterface $paramFetcher, SerializerInterface $serializer, UserPasswordEncoderInterface $passwordEncoder, ValidatorInterface $validator, User $user)
    {

        $errors = $validator->validate($user, null, ['Registration']);
        // $user->setProfilePicture($data["profile_picture"]);
        // $user->setCroppedProfilePicture($data["cropped_profile_picture"]);

        if (count($errors) > 0) {

            $errorResponse = [];
            foreach($errors as $error){

                $errorResponse[] = ["message" => $error->getMessage()];

            }
            

            return ["ok" => false, "errors" => $errorResponse];
        }

        $user->setPassword($passwordEncoder->encodePassword(
                     $user,
                     $user->getPlainPassword()
                 ));        
        // $user->setEnabled(true);

        $user->eraseCredentials();

        $entityManager = $this->getDoctrine()->getManager();
        $entityManager->persist($user);
        $entityManager->flush();


        return ['ok' => true ];
        
      

    }  

    /**
     * @Rest\Get(
     *  "api/user/user.{_format}"
     *)
     * @Rest\View(serializerGroups={"user"})     
     * @QueryParam(name="user_id", requirements="\d+", default="", description="User Id.")
     */
    public function userAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();

        $userId = $paramFetcher->get('user_id');

        if ( $userId ) {

            $repository = $this->getDoctrine()->getRepository(User::class);
            $user = $repository->find($userId);

            if (! $user)
                return [];

            $favoritesRepo = $this->getDoctrine()->getRepository(Favorite::class);

            $favorite = $favoritesRepo->findOneBy(['owner' => $currentUser , 'favorited' => $userId ]);

            if ( $favorite )
                $user->setIsFavorited(true);

        } else  {
            
            $user = $currentUser;

        }

        return $user;
      

    }           

    /**
     * @Rest\Post(
     *  "api/user/user.{_format}"
     *)
     * @ParamConverter("user", converter="fos_rest.request_body")     
     */
    public function editProfileAction(Request $request, ParamFetcherInterface $paramFetcher, ValidatorInterface $validator, UserPasswordEncoderInterface $passwordEncoder, User $user)
    {

        $currentUser = $this->getUser();

        if ( !$currentUser )
            return ['ok' => false];

        $user->setId( $currentUser->getId() );
        
        $errors = $validator->validate($user, null, [ $user->getPlainPassword() ? 'Registration' : 'Profile'  ]);

        if (count($errors) > 0) {

            $errorResponse = [];
            foreach($errors as $error){

                $errorResponse[] = ["message" => $error->getMessage()];

            }
            

            return ["ok" => false, "errors" => $errorResponse];
        }


        if ( $user->getPlainPassword() ) {
            
            $user->setPassword($passwordEncoder->encodePassword(
                         $user,
                         $user->getPlainPassword()
                     ));        
        } else {
            $user->setPassword($currentUser->getPassword());
        }

        $user->eraseCredentials();

        $entityManager = $this->getDoctrine()->getManager();
        $entityManager->persist($user);
        $entityManager->flush();


        return ['ok' => true ];

      

    }       

    /**
     * @Rest\Get(
     *  "api/recover.{_format}"
     *)
     * @QueryParam(name="email", requirements=@Constraints\Email), strict="true", nullable="false", description="Email.")
     * @QueryParam(name="lang", requirements="(es|en)", default="en", description="Language.")
     */
    public function recoverAction(Request $request, ParamFetcherInterface $paramFetcher, UserPasswordEncoderInterface $passwordEncoder, StringHelper $helper, TranslatorInterface $translator, \Swift_Mailer $mailer)
    {

        $email = $paramFetcher->get('email');
        $language = $paramFetcher->get('lang');

        if(!in_array($language, ['es', 'en']))
            $language = "en";

        $request->setLocale($language);

        $em = $this->getDoctrine()->getManager();
        $repo = $em->getRepository(User::class);
        $user = $repo->findOneBy(['email' => $email]);

        if ( $user ) {

            $newPassword = $helper->generateRandomString(20);
            $user->setPassword($passwordEncoder->encodePassword(
                         $user,
                         $newPassword
                     ));        

            $user->eraseCredentials();

            $em->flush();


             $message = (new \Swift_Message($translator->trans('recover_password_email_subject')))
                    ->setFrom("no-reply@osedax.app")
                    ->setTo($email)
                    ->setBody(
                        $this->renderView(
                            // templates/emails/registration.html.twig
                            'emails/recover.html.twig',
                            ['password' => $newPassword]
                        ),
                        'text/html'
                    )

                    // you can remove the following code if you don't define a text version for your emails
                    ->addPart(
                        $this->renderView(
                            // templates/emails/registration.txt.twig
                            'emails/recover.txt.twig',
                            ['password' => $newPassword]
                        ),
                        'text/plain'
                    )
                ;

                $mailer->send($message);


            return ['ok' => true ];

        }     

        return ['ok' => false ];
        
      

    }              


    /**
     * @Rest\Get(
     *  "api/user/chapters.{_format}"
     *)
     * @Rest\View(serializerGroups={"chapter"})     
     * @QueryParam(name="lang", requirements="(es|en|es\-AR)", default="en", description="Language.")
     * @QueryParam(name="full", requirements="(true|false)", default="false", description="Full.")
     * @QueryParam(name="version", requirements="\d+", nullable=true, default=0, description="Version.")
     */
    public function chaptersAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();
        $em = $this->getDoctrine()->getManager();
        $repo = $em->getRepository(Chapter::class);
        $repoEpisodes = $em->getRepository(Episode::class);
            
        $language = $paramFetcher->get('lang');
        $full = $paramFetcher->get('full') == 'true';
        $version = $paramFetcher->get('version');        

        $currentUser->setLanguage($language);
        $em->flush();

        if(!in_array($language, ['es', 'en', 'es-AR']))
            $language = "en";

        $purchases = $currentUser->getPurchases();

        $chapters = $repo->findChapters($language, $version);

        foreach ($chapters as &$chapter) {

            $episodes = $repoEpisodes->findEpisodes($chapter, $language);
            foreach ($episodes as $episode)
                $chapter->addEpisode($episode);


            foreach ($purchases as $purchase) {
                
                if ( $chapter->getId() == $purchase->getChapter()->getId()  ) {

                    $chapter->setPurchased(true);
                    break;

                }

            }

        }

        if(!$full) foreach ($chapters as &$chapter) {

            if ( !$chapter->getPurchased() ) {
                $i = 0;
                foreach ($chapter->getEpisodes() as &$episode){
                    $i++;
                    if ($i>1){
                        $episode->setText(null);
                        $episode->setText2(null);
                        $episode->setImage(null);
                    }
                }


            }

        }


        // foreach ($purchases as $purchase) {

        //     foreach ($chapters as &$chapter) {


        //         if ( $chapter->getId() == $purchase->getChapter()->getId()  ) {
        //             $episodes = $repoEpisodes->findEpisodes($chapter, $language);
        //             foreach ($episodes as $episode)
        //                 $chapter->addEpisode($episode);


        //             $chapter->setPurchased(true);
        //             continue;

        //         }

        //     }

        // }

        // foreach ($chapters as &$chapter) {

        //     if ( !$chapter->getPurchased() ) {
                
        //         foreach ($chapter->getEpisodes() as &$episode){
        //             $episode->setText(null);
        //             $episode->setImage(null);
        //         }


        //     }

        // }


        // if ( $user =  ) {

        //     $purchases = $user->getPurchases();        

            
        //     foreach ($purchases as $purchase ) {
                    
        //         $chapter = $purchase->getChapter();

        //         $chapter->setTranslatableLocale('es');

        //         $em->refresh($chapter);            

        //         $chapters[] = $chapter;

                

        //     }

        // }

        return $chapters;
        
      

    }  

    /**
     * @Rest\Get(
     *  "api/user/init.{_format}"
     *)
     * @Rest\View(serializerGroups={"init"})     
     */
    public function initAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();
            
        $em = $this->getDoctrine()->getManager();
        $repoTextClippings = $em->getRepository(TextClipping::class);
        $repoBookmarks = $em->getRepository(Bookmark::class);
        $repoCharacterSelects = $em->getRepository(CharacterSelect::class);

        return [
            'text_clippings' => $repoTextClippings->findBy(['user' => $currentUser]),
            'bookmarks' => $repoBookmarks->findBy(['user' => $currentUser]),
            'character_selects' => $repoCharacterSelects->findBy(['user' => $currentUser]),
        ];


    }

    /**
     * @Rest\Post(
     *  "api/user/purchase.{_format}"
     *)
     * @Rest\Get(
     *  "api/user/purchase.{_format}"
     *)     
     * @Rest\View(serializerGroups={"chapter"})     
     * @QueryParam(name="sku", requirements=".*", nullable=false, description="Sku.")
     * @QueryParam(name="lang", requirements="(es|en)", default="en", description="Language.")
     */
    public function purchaseAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();
        $em = $this->getDoctrine()->getManager();
        $repo = $em->getRepository(Chapter::class);
        $purchasesRepo = $em->getRepository(Purchase::class);
        $episodesRepo = $em->getRepository(Episode::class);
        
        $sku = $paramFetcher->get('sku');
        $language = $paramFetcher->get('lang');

        if(!in_array($language, ['es', 'en']))
            $language = "en";

        $chapter = $repo->findOneBy(['sku' => $sku]);

        if ($chapter) {
            $purchase = $purchasesRepo->findOneBy(['user' => $currentUser, 'chapter' => $chapter]);

            if(!$purchase) {

                $purchase = new Purchase;
                $purchase->setUser($currentUser);
                $purchase->setChapter($chapter);
                $em->persist($purchase);
                $em->flush();


            }
        }

        $purchases = $currentUser->getPurchases();


        $episodes = $episodesRepo->findEpisodes($chapter, $language);
        foreach ($episodes as $episode)
            $chapter->addEpisode($episode);

        $chapter->setPurchased(true);

        return $chapter;
        
      

    }      

    /**
     * @Rest\Post(
     *  "api/user/text_clipping.{_format}"
     *)     
     * @ParamConverter("textClipping", converter="fos_rest.request_body")     
     */
    public function textClippingCreateAction(Request $request, ParamFetcherInterface $paramFetcher, TextClipping $textClipping)
    {

        $currentUser = $this->getUser();

        $textClipping->setUser($currentUser);

        $em = $this->getDoctrine()->getManager();
        $em->persist($textClipping);
        $em->flush();

        return ['ok' => true];

    }  

    /**
     * @Rest\Delete(
     *  "api/user/text_clipping_delete.{_format}"
     *)     
     * @QueryParam(name="text_clipping_id", requirements="\d+", default="", description="Text Clipping Id.")
     */
    public function textClippingDeleteAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();

        $textClippingId = $paramFetcher->get('text_clipping_id');

        $em = $this->getDoctrine()->getManager();
        $repository = $this->getDoctrine()->getRepository(TextClipping::class);
        $textClipping = $repository->findOneBy(['foreignId' => $textClippingId, 'user' => $currentUser ]);

        if($textClipping && $textClipping->getUser()->getId() == $currentUser->getId() ) {
            $em->remove($textClipping);
            $em->flush();            
        }

        return ['ok' => true];

    }      


    /**
     * @Rest\Post(
     *  "api/user/bookmark.{_format}"
     *)     
     * @ParamConverter("bookmark", converter="fos_rest.request_body")     
     */
    public function bookmarkCreateAction(Request $request, ParamFetcherInterface $paramFetcher, Bookmark $bookmark)
    {

        $currentUser = $this->getUser();

        $repository = $this->getDoctrine()->getRepository(Bookmark::class);
        $em = $this->getDoctrine()->getManager();

        $existingBookmark = $repository->findOneBy(['user' => $currentUser]);
        
        if($existingBookmark){
            
            $em->remove($existingBookmark);
        } 

        $bookmark->setUser($currentUser);    
        $em->persist($bookmark);
        $em->flush();

        return ['ok' => true];

    }  

    /**
     * @Rest\Post(
     *  "api/user/character_select.{_format}"
     *)     
     * @ParamConverter("characterSelect", converter="fos_rest.request_body")     
     */
    public function CharacterSelectCreateAction(Request $request, ParamFetcherInterface $paramFetcher, CharacterSelect $characterSelect)
    {

        $currentUser = $this->getUser();

        $em = $this->getDoctrine()->getManager();
        $repository = $this->getDoctrine()->getRepository(CharacterSelect::class);

        $existingCharacterSelect = $repository->findOneByCharacterName($currentUser, $characterSelect->getName());

        if(!$existingCharacterSelect){

            $characterSelect->setUser($currentUser);
            $em->persist($characterSelect);

        } else {

            $existingCharacterSelect->setCharacterOption($characterSelect->getCharacterOption());

        }

        
        
        $em->flush();

        return ['ok' => true];

    }  

    /**
     * @Rest\Get(
     *  "api/user/chapters_after.{_format}"
     *)
     * @Rest\View(serializerGroups={"chapter"})     
     * @QueryParam(name="lang", requirements="(es|en)", default="en", description="Language.")
     * @QueryParam(name="id", requirements="\d+", nullable=false, strict=true, description="Chapter Id.")
     * @QueryParam(name="full", requirements="(true|false)", default="false", description="Full.")
     * @QueryParam(name="version", requirements="\d+", nullable=true, default=0, description="Version.")
     */
    public function chaptersAfterAction(Request $request, ParamFetcherInterface $paramFetcher)
    {

        $currentUser = $this->getUser();
        $em = $this->getDoctrine()->getManager();
        $repo = $em->getRepository(Chapter::class);
        $repoEpisodes = $em->getRepository(Episode::class);
            
        $language = $paramFetcher->get('lang');
        $chapterId = intval($paramFetcher->get('id'));
        $full = $paramFetcher->get('full') == 'true';
        $version = $paramFetcher->get('version');        

        $currentUser->setLanguage($language);
        $em->flush();

        if(!in_array($language, ['es', 'en']))
            $language = "en";

        $purchases = $currentUser->getPurchases();

        $chapters = $repo->findChaptersAfter($language, $chapterId, $version);

        foreach ($chapters as &$chapter) {

            $episodes = $repoEpisodes->findEpisodes($chapter, $language);
            foreach ($episodes as $episode)
                $chapter->addEpisode($episode);


            foreach ($purchases as $purchase) {
                
                if ( $chapter->getId() == $purchase->getChapter()->getId()  ) {

                    $chapter->setPurchased(true);
                    break;

                }

            }

        }

        if(!$full) foreach ($chapters as &$chapter) {

            if ( !$chapter->getPurchased() ) {
                $i = 0;
                foreach ($chapter->getEpisodes() as &$episode){
                    $i++;
                    if ($i>1){
                        $episode->setText(null);
                        $episode->setText2(null);
                        $episode->setImage(null);
                    }
                }


            }

        }

        return $chapters;
        
      

    }      


    /**
     * @Rest\Get(
     *  "api/test.{_format}"
     *)
     * @Rest\View(serializerGroups={"user"})     
     */
    public function testAction(Request $request, TranslatorInterface $translator, \Swift_Mailer $mailer)
    {

        $to = "gustavorago@gmail.com";

         $message = (new \Swift_Message("Hay un nuevo capítulo disponible"))
                ->setFrom("no-reply@osedax.app")
                ->setTo($to)
                ->setBody(
                    $this->renderView(
                        // templates/emails/registration.html.twig
                        'emails/newsletter.html.twig',
                        [
                            "link" => $this->generateUrl('app_api_applink', ['_format' => 'json'], UrlGenerator::ABSOLUTE_URL) ,
                            "link_remove" => $this->generateUrl('app_api_newsletterremove', ['_format' => 'json', 'email' => $to], UrlGenerator::ABSOLUTE_URL) ,
                        ]
                    ),
                    'text/html'
                )
            ;

            $mailer->send($message);


        return ['ok' => true ];



         // $token = (new Builder())
         //    ->withClaim('mercure', ['subscribe' => ["*", "http://api.naipesnegros.com/targets/subscriptions"], 'publish' => ["*", "http://api.naipesnegros.com/targets/subscriptions"]]) 
         //    ->getToken(new Sha256(), new Key($this->getParameter('mercure_secret_key'))); 

        
        // $update = new Update(
        //     "https://chat.example.com/messages/1",
        //     json_encode(['hola' => 'si'])
        //     , []
        //     , null
        // );

        // // The Publisher service is an invokable object
        // $publisher($update);

        return ["ok" => true];

        // return ["ok" => (string) $token];
        
      

    }  

    /**
     * @Rest\Get(
     *  "api/app_link.{_format}"
     *)
     */
    public function appLinkAction(Request $request)
    {


        $useragent = $request->headers->get('User-Agent');

        $iPod    = stripos($useragent,"iPod");
        $iPhone  = stripos($useragent,"iPhone");
        $iPad    = stripos($useragent,"iPad");        

        if($iPod || $iPhone || $iPad)
            return $this->redirect('https://apps.apple.com/us/app/osedax/id1566266974?itsct=apps_box_link&itscg=30200');
        else
            return $this->redirect('https://play.google.com/store/apps/details?id=com.blkpos.osedax');

    }      

    /**
     * @Rest\Get(
     *  "api/newsletter_remove.{_format}"
     *)
     * @QueryParam(name="email", requirements=".*", default=null, nullable=true, description="Email.")
     */
    public function newsletterRemoveAction(Request $request, ParamFetcherInterface $paramFetcher)
    {


        $email = $paramFetcher->get('email');

        if($email){
            $repository = $this->getDoctrine()->getRepository(User::class);
            $user = $repository->findOneBy(['email' => trim($email)]);

            if($user){
                $user->setEmailNotifications(false);
                $this->getDoctrine()->getManager()->flush();
            }

        }

        return new Response("Has sido removido de la lista de correos.");

        

    }        
}
