<?php

namespace App\Entity;

use App\Repository\TextClippingRepository;
use Doctrine\ORM\Mapping as ORM;
use Gedmo\Timestampable\Traits\TimestampableEntity;
use JMS\Serializer\Annotation\Groups;

/**
 * @ORM\Entity(repositoryClass=TextClippingRepository::class)
 */
class TextClipping
{

    use TimestampableEntity;

    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="text")
     * @Groups({"init"})
     */
    private $text;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"init"})
     */
    private $indexStart;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"init"})
     */
    private $indexEnd;

    /**
     * @ORM\ManyToOne(targetEntity=Chapter::class)
     * @ORM\JoinColumn(nullable=false)
     * @Groups({"init"})
     */
    private $chapter;

    /**
     * @ORM\ManyToOne(targetEntity=Episode::class)
     * @ORM\JoinColumn(nullable=false)
     * @Groups({"init"})
     */
    private $episode;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"init"})
     */
    private $position;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"init"})
     */
    private $paragraph;

    /**
     * @ORM\Column(type="string", length=2)
     * @Groups({"init"})
     */
    private $language;

    /**
     * @ORM\ManyToOne(targetEntity=User::class)
     * @ORM\JoinColumn(nullable=false)
     */
    private $user;

    /**
     * @ORM\Column(type="integer")
     */
    private $foreignId;

    /**
     * @ORM\Column(type="text", nullable=true)
     */
    private $characterCode;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getText(): ?string
    {
        return $this->text;
    }

    public function setText(string $text): self
    {
        $this->text = $text;

        return $this;
    }

    public function getIndexStart(): ?int
    {
        return $this->indexStart;
    }

    public function setIndexStart(int $indexStart): self
    {
        $this->indexStart = $indexStart;

        return $this;
    }

    public function getIndexEnd(): ?int
    {
        return $this->indexEnd;
    }

    public function setIndexEnd(int $indexEnd): self
    {
        $this->indexEnd = $indexEnd;

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

    public function getEpisode(): ?Episode
    {
        return $this->episode;
    }

    public function setEpisode(?Episode $episode): self
    {
        $this->episode = $episode;

        return $this;
    }

    public function getPosition(): ?int
    {
        return $this->position;
    }

    public function setPosition(int $position): self
    {
        $this->position = $position;

        return $this;
    }

    public function getParagraph(): ?int
    {
        return $this->paragraph;
    }

    public function setParagraph(int $paragraph): self
    {
        $this->paragraph = $paragraph;

        return $this;
    }

    public function getLanguage(): ?string
    {
        return $this->language;
    }

    public function setLanguage(string $language): self
    {
        $this->language = $language;

        return $this;
    }

    public function getUser(): ?User
    {
        return $this->user;
    }

    public function setUser(?User $user): self
    {
        $this->user = $user;

        return $this;
    }

    public function getForeignId(): ?int
    {
        return $this->foreignId;
    }

    public function setForeignId(int $foreignId): self
    {
        $this->foreignId = $foreignId;

        return $this;
    }

    public function getCharacterCode(): ?string
    {
        return $this->characterCode;
    }

    public function setCharacterCode(?string $characterCode): self
    {
        $this->characterCode = $characterCode;

        return $this;
    }

}
