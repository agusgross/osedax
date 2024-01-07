<?php

namespace App\Entity;

use App\Repository\ChapterRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Gedmo\Mapping\Annotation as Gedmo;
use Gedmo\Timestampable\Traits\TimestampableEntity;
use JMS\Serializer\Annotation\Groups;
use Gedmo\Translatable\Translatable;

/**
 * @ORM\Entity(repositoryClass=ChapterRepository::class)
 */
class Chapter implements Translatable
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
     * @ORM\OneToMany(targetEntity=Episode::class, mappedBy="chapter", orphanRemoval=true, cascade={"persist"})
     * @Groups({"chapter"})
     */
    private $episodes;

    /**
     * @Gedmo\Locale
     * Used locale to override Translation listener`s locale
     * this is not a mapped field of entity metadata, just a simple property
     */
    private $locale;

    /**
     * @ORM\Column(type="text")
     * @Gedmo\Translatable
     * @Groups({"chapter"})
     */
    private $title;

    /**
     * @Groups({"chapter"})
     */
    private $purchased = false;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"chapter"})
     */
    private $numberOfCharacters = 0;

    /**
     * @ORM\Column(type="string", length=255)
     * @Groups({"chapter"})
     */
    private $characterOneOptionA = "";

    /**
     * @ORM\Column(type="string", length=255)
     * @Groups({"chapter"})
     */
    private $characterOneOptionB = "";

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterTwoOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterTwoOptionB;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterThreeOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterThreeOptionB;

    /**
     * @ORM\Column(type="string", length=255)
     * @Groups({"chapter"})
     */
    private $characterOneName;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterTwoName;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterThreeName;

    /**
     * @ORM\Column(type="string", length=10)
     * @Groups({"chapter"})
     */
    private $sku;

    /**
     * @ORM\Column(type="integer", nullable=true)
     */
    private $version;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFourOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFourOptionB;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFourName;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFiveOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFiveOptionB;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterFiveName;    

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSixOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSixOptionB;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSixName;        

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSevenOptionA;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSevenOptionB;

    /**
     * @ORM\Column(type="string", length=255, nullable=true)
     * @Groups({"chapter"})
     */
    private $characterSevenName;        

    public function __construct()
    {
        $this->episodes = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    /**
     * @return Collection|Episode[]
     */
    public function getEpisodes(): Collection
    {
        return $this->episodes;
    }

    public function addEpisode(Episode $episode): self
    {
        if (!$this->episodes->contains($episode)) {
            $this->episodes[] = $episode;
            $episode->setChapter($this);
        }

        return $this;
    }

    public function removeEpisode(Episode $episode): self
    {
        if ($this->episodes->contains($episode)) {
            $this->episodes->removeElement($episode);
            // set the owning side to null (unless already changed)
            if ($episode->getChapter() === $this) {
                $episode->setChapter(null);
            }
        }

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

    public function setTranslatableLocale($locale)
    {
        $this->locale = $locale;
    }

    public function getPurchased(): ?bool
    {
        return $this->purchased;
    }

    public function setPurchased(bool $purchased): self
    {
        $this->purchased = $purchased;

        return $this;
    }

    public function getNumberOfCharacters(): ?int
    {
        return $this->numberOfCharacters;
    }

    public function setNumberOfCharacters(int $numberOfCharacters): self
    {
        $this->numberOfCharacters = $numberOfCharacters;

        return $this;
    }

    public function getCharacterOneOptionA(): ?string
    {
        return $this->characterOneOptionA;
    }

    public function setCharacterOneOptionA(string $characterOneOptionA): self
    {
        $this->characterOneOptionA = $characterOneOptionA;

        return $this;
    }

    public function getCharacterOneOptionB(): ?string
    {
        return $this->characterOneOptionB;
    }

    public function setCharacterOneOptionB(string $characterOneOptionB): self
    {
        $this->characterOneOptionB = $characterOneOptionB;

        return $this;
    }

    public function getCharacterTwoOptionA(): ?string
    {
        return $this->characterTwoOptionA;
    }

    public function setCharacterTwoOptionA(?string $characterTwoOptionA): self
    {
        $this->characterTwoOptionA = $characterTwoOptionA;

        return $this;
    }

    public function getCharacterTwoOptionB(): ?string
    {
        return $this->characterTwoOptionB;
    }

    public function setCharacterTwoOptionB(?string $characterTwoOptionB): self
    {
        $this->characterTwoOptionB = $characterTwoOptionB;

        return $this;
    }

    public function getCharacterThreeOptionA(): ?string
    {
        return $this->characterThreeOptionA;
    }

    public function setCharacterThreeOptionA(?string $characterThreeOptionA): self
    {
        $this->characterThreeOptionA = $characterThreeOptionA;

        return $this;
    }

    public function getCharacterThreeOptionB(): ?string
    {
        return $this->characterThreeOptionB;
    }

    public function setCharacterThreeOptionB(?string $characterThreeOptionB): self
    {
        $this->characterThreeOptionB = $characterThreeOptionB;

        return $this;
    }

    public function getCharacterOneName(): ?string
    {
        return $this->characterOneName;
    }

    public function setCharacterOneName(string $characterOneName): self
    {
        $this->characterOneName = $characterOneName;

        return $this;
    }

    public function getCharacterTwoName(): ?string
    {
        return $this->characterTwoName;
    }

    public function setCharacterTwoName(?string $characterTwoName): self
    {
        $this->characterTwoName = $characterTwoName;

        return $this;
    }

    public function getCharacterThreeName(): ?string
    {
        return $this->characterThreeName;
    }

    public function setCharacterThreeName(?string $characterThreeName): self
    {
        $this->characterThreeName = $characterThreeName;

        return $this;
    }

    public function getSku(): ?string
    {
        return $this->sku;
    }

    public function setSku(string $sku): self
    {
        $this->sku = $sku;

        return $this;
    }

    public function getVersion(): ?int
    {
        return $this->version;
    }

    public function setVersion(?int $version): self
    {
        $this->version = $version;

        return $this;
    }

    public function getCharacterFourOptionA(): ?string
    {
        return $this->characterFourOptionA;
    }

    public function setCharacterFourOptionA(?string $characterFourOptionA): self
    {
        $this->characterFourOptionA = $characterFourOptionA;

        return $this;
    }

    public function getCharacterFourOptionB(): ?string
    {
        return $this->characterFourOptionB;
    }

    public function setCharacterFourOptionB(?string $characterFourOptionB): self
    {
        $this->characterFourOptionB = $characterFourOptionB;

        return $this;
    }

    public function getCharacterFourName(): ?string
    {
        return $this->characterFourName;
    }

    public function setCharacterFourName(?string $characterFourName): self
    {
        $this->characterFourName = $characterFourName;

        return $this;
    }

    public function getCharacterFiveOptionA(): ?string
    {
        return $this->characterFiveOptionA;
    }

    public function setCharacterFiveOptionA(?string $characterFiveOptionA): self
    {
        $this->characterFiveOptionA = $characterFiveOptionA;

        return $this;
    }

    public function getCharacterFiveOptionB(): ?string
    {
        return $this->characterFiveOptionB;
    }

    public function setCharacterFiveOptionB(?string $characterFiveOptionB): self
    {
        $this->characterFiveOptionB = $characterFiveOptionB;

        return $this;
    }

    public function getCharacterFiveName(): ?string
    {
        return $this->characterFiveName;
    }

    public function setCharacterFiveName(?string $characterFiveName): self
    {
        $this->characterFiveName = $characterFiveName;

        return $this;
    }

    public function getCharacterSixOptionA(): ?string
    {
        return $this->characterSixOptionA;
    }

    public function setCharacterSixOptionA(?string $characterSixOptionA): self
    {
        $this->characterSixOptionA = $characterSixOptionA;

        return $this;
    }

    public function getCharacterSixOptionB(): ?string
    {
        return $this->characterSixOptionB;
    }

    public function setCharacterSixOptionB(?string $characterSixOptionB): self
    {
        $this->characterSixOptionB = $characterSixOptionB;

        return $this;
    }

    public function getCharacterSixName(): ?string
    {
        return $this->characterSixName;
    }

    public function setCharacterSixName(?string $characterSixName): self
    {
        $this->characterSixName = $characterSixName;

        return $this;
    }    

    public function getCharacterSevenOptionA(): ?string
    {
        return $this->characterSevenOptionA;
    }

    public function setCharacterSevenOptionA(?string $characterSevenOptionA): self
    {
        $this->characterSevenOptionA = $characterSevenOptionA;

        return $this;
    }

    public function getCharacterSevenOptionB(): ?string
    {
        return $this->characterSevenOptionB;
    }

    public function setCharacterSevenOptionB(?string $characterSevenOptionB): self
    {
        $this->characterSevenOptionB = $characterSevenOptionB;

        return $this;
    }

    public function getCharacterSevenName(): ?string
    {
        return $this->characterSevenName;
    }

    public function setCharacterSevenName(?string $characterSevenName): self
    {
        $this->characterSevenName = $characterSevenName;

        return $this;
    }        
}
