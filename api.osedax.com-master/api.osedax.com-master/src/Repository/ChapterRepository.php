<?php

namespace App\Repository;

use App\Entity\Chapter;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\ORM\Query;
use \Gedmo\Translatable\TranslatableListener;

/**
 * @method Chapter|null find($id, $lockMode = null, $lockVersion = null)
 * @method Chapter|null findOneBy(array $criteria, array $orderBy = null)
 * @method Chapter[]    findAll()
 * @method Chapter[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ChapterRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Chapter::class);
    }

    // /**
    //  * @return Chapter[] Returns an array of Chapter objects
    //  */
    /*
    public function findByExampleField($value)
    {
        return $this->createQueryBuilder('c')
            ->andWhere('c.exampleField = :val')
            ->setParameter('val', $value)
            ->orderBy('c.id', 'ASC')
            ->setMaxResults(10)
            ->getQuery()
            ->getResult()
        ;
    }
    */

    /*
    public function findOneBySomeField($value): ?Chapter
    {
        return $this->createQueryBuilder('c')
            ->andWhere('c.exampleField = :val')
            ->setParameter('val', $value)
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }
    */


    public function findChapter(Chapter $chapter, $locale = 'en')
    {
        $qb = $this->createQueryBuilder('c')
                ->where('c.id = :chapter')->setParameter('chapter', $chapter)
                // ->join('u.purchases', 'p')
                // ->join('p.chapter', 'c')
                // ->join('c.episodes', 'e')
        ;

        $query = $qb->getQuery();

        $query->setHint(\Gedmo\Translatable\TranslatableListener::HINT_FALLBACK, 1);
        $query->setHint(
            Query::HINT_CUSTOM_OUTPUT_WALKER,
            'Gedmo\\Translatable\\Query\\TreeWalker\\TranslationWalker'
        );

        $query->setHint(TranslatableListener::HINT_TRANSLATABLE_LOCALE, $locale);

        $query->useQueryCache(false);
        $query->disableResultCache();

        return $query->getOneOrNullResult();            
            
        
    }        

    public function findChapters($locale = 'en', $version = 0)
    {
        $qb = $this->createQueryBuilder('c')
            ->andWhere('c.version <= :version')->setParameter('version', $version)

        ;

        $query = $qb->getQuery();

        $query->setHint(\Gedmo\Translatable\TranslatableListener::HINT_FALLBACK, 1);
        $query->setHint(
            Query::HINT_CUSTOM_OUTPUT_WALKER,
            'Gedmo\\Translatable\\Query\\TreeWalker\\TranslationWalker'
        );

        $query->setHint(TranslatableListener::HINT_TRANSLATABLE_LOCALE, $locale);

        $query->useQueryCache(false);
        $query->disableResultCache();

        return $query->getResult();            
            
        
    }            

    public function findChaptersAfter($locale = 'en', int $chapterId, $version = 0)
    {
        $qb = $this->createQueryBuilder('c')
            ->andWhere('c.id > :chapterId')->setParameter('chapterId', $chapterId)
            ->andWhere('c.version <= :version')->setParameter('version', $version)

        ;

        $query = $qb->getQuery();

        $query->setHint(\Gedmo\Translatable\TranslatableListener::HINT_FALLBACK, 1);
        $query->setHint(
            Query::HINT_CUSTOM_OUTPUT_WALKER,
            'Gedmo\\Translatable\\Query\\TreeWalker\\TranslationWalker'
        );

        $query->setHint(TranslatableListener::HINT_TRANSLATABLE_LOCALE, $locale);

        $query->useQueryCache(false);
        $query->disableResultCache();

        return $query->getResult();            
            
        
    }     

            
}
