<?php

namespace App\DataFixtures;

use Symfony\Component\HttpKernel\KernelInterface;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

use Gedmo\Translatable\Entity\Translation;

use App\Entity\Chapter;
use App\Entity\Episode;

class AppFixtures extends Fixture
{
    protected $appKernel;

    public function __construct(KernelInterface $appKernel)
    {
        $this->appKernel = $appKernel;
    }    

    public function load(ObjectManager $manager)
    {
        // $product = new Product();
        // $manager->persist($product);

        $translatableRepo = $manager->getRepository(Translation::class);

        $episodes = [];

        // $episodes[] = $this->addEpisode(['episode_number' => 1, 'title_en' => 'Absent', 'title_es' => 'Ausente', 'image' => 'image_1_1', 'is_first_character_present' => true, 'is_second_character_present' => false, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1b_es.txt")], $manager, $translatableRepo);
        // $episodes[] = $this->addEpisode(['episode_number' => 2, 'title_en' => 'Floating', 'title_es' => 'Flotando', 'image' => 'image_1_2', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2b_es.txt")], $manager, $translatableRepo);
        // $episodes[] = $this->addEpisode(['episode_number' => 3, 'title_en' => 'Screens', 'title_es' => 'Pantallas', 'image' => 'image_1_3', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3b_es.txt")], $manager, $translatableRepo);        
        // $episodes[] = $this->addEpisode(['episode_number' => 4, 'title_en' => 'Plants', 'title_es' => 'Plantas', 'image' => 'image_1_4', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => true, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4b_es.txt")], $manager, $translatableRepo);        

        // $characters = [
            // ["images" => ["character1_a", "character1_b" ], "name" => "RE+9725" ],
            // ["images" => ["character2_a", "character2_b" ], "name" => "BI+6875" ],
            // ["images" => ["character3_a", "character3_b" ], "name" => "NU+8715" ],


        // ];

        // $this->addChapter(['title_en' => 'Uno', 'title_es' => 'Uno'], $episodes, $characters, $manager, $translatableRepo);

        $episodes[] = $this->addEpisode(['episode_number' => 1, 'title_en' => 'Absent2', 'title_es' => 'Ausente2', 'image' => 'image_1_1', 'is_first_character_present' => true, 'is_second_character_present' => false, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_1b_es.txt")], $manager, $translatableRepo);
        $episodes[] = $this->addEpisode(['episode_number' => 2, 'title_en' => 'Floating2', 'title_es' => 'Flotando2', 'image' => 'image_1_2', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_2b_es.txt")], $manager, $translatableRepo);
        $episodes[] = $this->addEpisode(['episode_number' => 3, 'title_en' => 'Screens2', 'title_es' => 'Pantallas2', 'image' => 'image_1_3', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => false, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_3b_es.txt")], $manager, $translatableRepo);        
        $episodes[] = $this->addEpisode(['episode_number' => 4, 'title_en' => 'Plants2', 'title_es' => 'Plantas2', 'image' => 'image_1_4', 'is_first_character_present' => true, 'is_second_character_present' => true, 'is_third_character_present' => true, 'text_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4_en.txt"), 'text_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4_es.txt"), 'text2_en' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4b_en.txt"), 'text2_es' => file_get_contents($this->appKernel->getProjectDir() . "/texts/1_4b_es.txt")], $manager, $translatableRepo);        

        $characters = [
            ["images" => ["character1_a", "character1_b" ], "name" => "RE+9725" ],
            ["images" => ["character2_a", "character2_b" ], "name" => "BI+6875" ],
            ["images" => ["character3_a", "character3_b" ], "name" => "NU+8715" ],


        ];

        $this->addChapter(['title_en' => 'Dos', 'title_es' => 'Dos'], $episodes, $characters, $manager, $translatableRepo);



        $manager->flush();
    }

    function addEpisode($data, $manager, $translatableRepo){

        $episode = new Episode();
        $episode->setEpisodeNumber($data['episode_number']);
        $episode->setTitle($data['title_en']);
        $episode->setText($data['text_en']);
        $episode->setText2($data['text2_en']);
        $episode->setImage($data['image']);
        $episode->setIsFirstCharacterPresent($data['is_first_character_present']);
        $episode->setIsSecondCharacterPresent($data['is_second_character_present']);
        $episode->setisThirdCharacterPresent($data['is_third_character_present']);

        $translatableRepo->translate($episode, 'title', 'en', $data['title_en'])
            ->translate($episode, 'title', 'es', $data['title_es'])
            ->translate($episode, 'text', 'en', $data['text_en'])
            ->translate($episode, 'text', 'es', $data['text_es'])
            ->translate($episode, 'text2', 'en', $data['text2_en'])
            ->translate($episode, 'text2', 'es', $data['text2_es']);

        $manager->persist($episode);
        return $episode;

    }


    function addChapter($data, $episodes, $characters, $manager, $translatableRepo){

        $chapter = new Chapter();
        $chapter->setTitle($data['title_en']);

        $translatableRepo->translate($chapter, 'title', 'en', $data['title_en'])
            ->translate($chapter, 'title', 'es', $data['title_es']);

        
        foreach ($episodes as $episode) {
            $chapter->addEpisode($episode);
        }

        $chapter->setNumberOfCharacters(count($characters));

        $chapter->setCharacterOneOptionA($characters[0]["images"][0]);
        $chapter->setCharacterOneOptionB($characters[0]["images"][1]);
        $chapter->setCharacterOneName($characters[0]["name"]);


        if($chapter->getNumberOfCharacters() > 1){
            $chapter->setCharacterTwoOptionA($characters[1]["images"][0]);
            $chapter->setCharacterTwoOptionB($characters[1]["images"][1]);
            $chapter->setCharacterTwoName($characters[1]["name"]);            
        }

        if($chapter->getNumberOfCharacters() > 2){
            $chapter->setCharacterThreeOptionA($characters[2]["images"][0]);
            $chapter->setCharacterThreeOptionB($characters[2]["images"][1]);
            $chapter->setCharacterThreeName($characters[2]["name"]);            
        }


        $manager->persist($chapter);
        return $chapter;

    }

}

