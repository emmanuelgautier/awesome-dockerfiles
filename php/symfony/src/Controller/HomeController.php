<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class HomeController
{
    #[Route('/', name: 'home', methods: ['GET'])]
    public function __invoke(): JsonResponse
    {
        return new JsonResponse([
            'message' => 'Welcome to Symfony!',
        ]);
    }
}
