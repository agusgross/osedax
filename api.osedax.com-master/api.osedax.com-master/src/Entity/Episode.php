<?php

namespace App\Entity;

use App\Repository\EpisodeRepository;
use Doctrine\ORM\Mapping as ORM;
use Gedmo\Mapping\Annotation as Gedmo;
use Gedmo\Timestampable\Traits\TimestampableEntity;
use JMS\Serializer\Annotation\Groups;
use Gedmo\Translatable\Translatable;


/**
 * @ORM\Entity(repositoryClass=EpisodeRepository::class)
 */
class Episode  implements Translatable
{
    
    use TimestampableEntity;

    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @ORM\Column(type="integer")
     * @Groups({"chapter", "init"})
     */
    private $id;

    /**
     * @ORM\Column(type="text")
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $text;

    /**
     * @ORM\Column(type="text")
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $title;

    /**
     * @ORM\Column(type="string", length=255)
     * @Groups({"chapter"})
     */
    private $image;

    /**
     * @ORM\ManyToOne(targetEntity=Chapter::class, inversedBy="episodes")
     * @ORM\JoinColumn(nullable=false)
     */
    private $chapter;

    /**
     * @Gedmo\Locale
     * Used locale to override Translation listener`s locale
     * this is not a mapped field of entity metadata, just a simple property
     */
    private $locale;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isFirstCharacterPresent = false;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isSecondCharacterPresent = false;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isThirdCharacterPresent = false;

    /**
     * @ORM\Column(type="text")
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $text2;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"chapter"})
     */
    private $episodeNumber;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isFourthCharacterPresent = false;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isFifthCharacterPresent = false;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isSixthCharacterPresent = false;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"chapter"})
     */
    private $isSeventhCharacterPresent = false;

    /**
     * @ORM\Column(type="text", nullable=true)
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $textByCharacters;

    /**
     * @ORM\Column(type="text", nullable=true)
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $text2ByCharacters;    

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getText(): ?string
    {
        return $this->text;
    }

    public function setText(?string $text): self
    {
        $this->text = $text;

        return $this;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(string $title): self
    {
        $this->title = $title;

        return $this;
    }

    public function getImage(): ?string
    {
        return $this->image;
    }

    public function setImage(?string $image): self
    {
        $this->image = $image;

        return $this;
    }

    public function getChapter(): ?Chapter
    {
        return $this->chapter;
    }

    public function setChapter(?Chapter $chapter): self
    {
        $this->chapter = $chapter;

        return $this;
    }

    public function setTranslatableLocale($locale)
    {
        $this->locale = $locale;
    }

    public function getIsFirstCharacterPresent(): ?bool
    {
        return $this->isFirstCharacterPresent;
    }

    public function setIsFirstCharacterPresent(bool $isFirstCharacterPresent): self
    {
        $this->isFirstCharacterPresent = $isFirstCharacterPresent;

        return $this;
    }

    public function getIsSecondCharacterPresent(): ?bool
    {
        return $this->isSecondCharacterPresent;
    }

    public function setIsSecondCharacterPresent(bool $isSecondCharacterPresent): self
    {
        $this->isSecondCharacterPresent = $isSecondCharacterPresent;

        return $this;
    }

    public function getIsThirdCharacterPresent(): ?bool
    {
        return $this->isThirdCharacterPresent;
    }

    public function setIsThirdCharacterPresent(bool $isThirdCharacterPresent): self
    {
        $this->isThirdCharacterPresent = $isThirdCharacterPresent;

        return $this;
    }

    public function getText2(): ?string
    {
        return $this->text2;
    }

    public function setText2(?string $text2): self
    {
        $this->text2 = $text2;

        return $this;
    }

    public function getEpisodeNumber(): ?int
    {
        return $this->episodeNumber;
    }

    public function setEpisodeNumber(int $episodeNumber): self
    {
        $this->episodeNumber = $episodeNumber;

        return $this;
    }

    public function getIsFourthCharacterPresent(): ?bool
    {
        return $this->isFourthCharacterPresent;
    }

    public function setIsFourthCharacterPresent(bool $isFourthCharacterPresent): self
    {
        $this->isFourthCharacterPresent = $isFourthCharacterPresent;

        return $this;
    }

    public function getIsFifthCharacterPresent(): ?bool
    {
        return $this->isFifthCharacterPresent;
    }

    public function setIsFifthCharacterPresent(bool $isFifthCharacterPresent): self
    {
        $this->isFifthCharacterPresent = $isFifthCharacterPresent;

        return $this;
    }

    public function getIsSixthCharacterPresent(): ?bool
    {
        return $this->isSixthCharacterPresent;
    }

    public function setIsSixthCharacterPresent(bool $isSixthCharacterPresent): self
    {
        $this->isSixthCharacterPresent = $isSixthCharacterPresent;

        return $this;
    }

    public function getIsSeventhCharacterPresent(): ?bool
    {
        return $this->isSeventhCharacterPresent;
    }

    public function setIsSeventhCharacterPresent(bool $isSeventhCharacterPresent): self
    {
        $this->isSeventhCharacterPresent = $isSeventhCharacterPresent;

        return $this;
    }

    public function getTextByCharacters(): ?string
    {
        return $this->textByCharacters;
    }

    public function setTextByCharacters(?string $textByCharacters): self
    {
        $this->textByCharacters = $textByCharacters;

        return $this;
    }

    public function getText2ByCharacters(): ?string
    {
        return $this->text2ByCharacters;
    }

    public function setText2ByCharacters(?string $text2ByCharacters): self
    {
        $this->text2ByCharacters = $text2ByCharacters;

        return $this;
    }    
}
