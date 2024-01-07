<?php
// src/EventSubscriber/LocaleSubscriber.php
namespace App\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Routing\RouterInterface;

class LocaleSubscriber implements EventSubscriberInterface
{

    private $defaultLocale;
    private $appLocales;
    private $router;

    public function __construct( $defaultLocale = 'en',  $appLocales = 'en|es', RouterInterface $router )
    {
        $this->defaultLocale = $defaultLocale;
        $this->appLocales = $appLocales;
        $this->router = $router;
    }


    public static function getSubscribedEvents()
    {
        // return the subscribed events, their methods and priorities
        return [
            KernelEvents::REQUEST => [
                ['onKernelRequest', 25],
            ]

        ];
    }

    public function onKernelRequest(GetResponseEvent $event)
    {

        if (!$event->isMasterRequest()) {
            // don't do anything if it's not the master request
            return;
        }

        $request = $event->getRequest();

        $language = $request->query->get('language');

        if ( $language )
            $request->setLocale($language);

    }


}