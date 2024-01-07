<?php

namespace App\Repository;

use App\Entity\CharacterSelect;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @method CharacterSelect|null find($id, $lockMode = null, $lockVersion = null)
 * @method CharacterSelect|null findOneBy(array $criteria, array $orderBy = null)
 * @method CharacterSelect[]    findAll()
 * @method CharacterSelect[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class CharacterSelectRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, CharacterSelect::class);
    }

    public function findOneByCharacterName(User $user, $name): ?CharacterSelect
    {
        return $this->createQueryBuilder('c')
            ->andWhere('c.user = :user')->setParameter('user', $user)
            ->andWhere('c.name = :name')->setParameter('name', $name)
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }

}
