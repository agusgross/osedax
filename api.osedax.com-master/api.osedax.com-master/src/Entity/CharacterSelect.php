<?php

namespace App\Entity;

use App\Repository\CharacterSelectRepository;
use Doctrine\ORM\Mapping as ORM;
use Gedmo\Timestampable\Traits\TimestampableEntity;
use JMS\Serializer\Annotation\Groups;

/**
 * @ORM\Entity(repositoryClass=CharacterSelectRepository::class)
 */
class CharacterSelect
{

    use TimestampableEntity;

    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\ManyToOne(targetEntity=User::class)
     * @ORM\JoinColumn(nullable=false)
     */
    private $user;

    /**
     * @ORM\Column(type="string", length=100)
     * @Groups({"init"})
     */
    private $name;

    /**
     * @ORM\Column(type="integer")
     * @Groups({"init"})
     */
    private $characterOption;

    public function getId(): ?int
    {
        return $this->id;
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

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getCharacterOption(): ?int
    {
        return $this->characterOption;
    }

    public function setCharacterOption(int $characterOption): self
    {
        $this->characterOption = $characterOption;

        return $this;
    }
}
