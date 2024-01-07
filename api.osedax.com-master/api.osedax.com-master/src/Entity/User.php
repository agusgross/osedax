<?php

namespace App\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Gedmo\Mapping\Annotation as Gedmo;
use Gedmo\Timestampable\Traits\TimestampableEntity;
use JMS\Serializer\Annotation\Groups;
use JMS\Serializer\Annotation\Type;
use Doctrine\ORM\Mapping\Index;

/**
 * @ORM\Entity(repositoryClass="App\Repository\UserRepository")
 * @Gedmo\SoftDeleteable(fieldName="deletedAt")
 * @ORM\Table(name="user", uniqueConstraints={@ORM\UniqueConstraint(name="email", columns={"email"}) } )
 */
class User implements UserInterface
{

    use TimestampableEntity;

    /**
     * @ORM\Id()
     * @ORM\GeneratedValue()
     * @ORM\Column(type="integer")
     * @Groups({"user", "lounge"})
     */
    private $id;

    /**
     * @ORM\Column(type="json")
     */
    private $roles = [];

    /**
     * @var string The hashed password
     * @ORM\Column(type="string")
     */
    private $password;

    /**
     * @var string 
     * @Type("string")
     */
    private $plainPassword;

    /**
     * @ORM\Column(type="string", length=40)
     * @Groups({"user"})
     */
    private $firstName;

    /**
     * @ORM\Column(type="string", length=40, nullable=true)
     * @Groups({"user"})
     */
    private $lastName;

    /**
     * @ORM\Column(type="string", length=100)
     * @Groups({"user"})
     */
    private $email;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\DeviceToken", mappedBy="user", orphanRemoval=true)
     */
    private $deviceTokens;

    /**
     * @ORM\Column(name="deleted_at", type="datetime", nullable=true)
     */
    private $deletedAt;

    /**
     * @ORM\Column(type="boolean")
     * @Groups({"user"})
     */
    private $emailNotifications = false;

    /**
     * @ORM\OneToMany(targetEntity=Purchase::class, mappedBy="user", orphanRemoval=true)
     */
    private $purchases;

    /**
     * @ORM\Column(type="string", length=5, nullable=true)
     */
    private $language = "es";

    /**
     * @ORM\Column(type="datetime", nullable=true)
     */
    private $emailSentAt;
    

    public function __construct()
    {
        $this->deviceTokens = new ArrayCollection();
        $this->purchases = new ArrayCollection();
    }


    public function getId(): ?int
    {
        return $this->id;
    }

    public function setId(int $id): self
    {
        $this->id = $id;

        return $this;
    }

    /**
     * @see UserInterface
     */
    public function getRoles(): array
    {
        $roles = $this->roles;
        // guarantee every user at least has ROLE_USER
        $roles[] = 'ROLE_USER';

        return array_unique($roles);
    }

    public function setRoles(array $roles): self
    {
        $this->roles = $roles;

        return $this;
    }

    /**
     * A visual identifier that represents this user.
     *
     * @see UserInterface
     */
    public function getUsername(): string
    {
        return (string) $this->username;
    }

    public function setUsername(string $username): self
    {
        $this->username = $username;

        return $this;
    }    

    /**
     * @see UserInterface
     */
    public function getPassword(): string
    {
        return (string) $this->password;
    }

    public function setPassword(string $password): self
    {
        $this->password = $password;

        return $this;
    }

    /**
     * @see UserInterface
     */
    public function getSalt()
    {
        // not needed when using the "bcrypt" algorithm in security.yaml
    }

    /**
     * @see UserInterface
     */
    public function eraseCredentials()
    {
        // If you store any temporary, sensitive data on the user, clear it here
        $this->plainPassword = null;
    }

    public function getPlainPassword(): ?string
    {
        return $this->plainPassword;
    }

    public function setPlainPassword(string $plainPassword): self
    {
        $this->plainPassword = $plainPassword;

        return $this;
    }

    public function getFirstName(): ?string
    {
        return $this->firstName;
    }

    public function setFirstName(string $firstName): self
    {
        $this->firstName = $firstName;

        return $this;
    }

    public function getLastName(): ?string
    {
        return $this->lastName;
    }

    public function setLastName(string $lastName): self
    {
        $this->lastName = $lastName;

        return $this;
    }

    public function getEmail(): ?string
    {
        return $this->email;
    }

    public function setEmail(string $email): self
    {
        $this->email = $email;

        return $this;
    }

    /**
     * @return Collection|DeviceToken[]
     */
    public function getDeviceTokens(): ArrayCollection
    {
        return $this->deviceTokens;
    }

    public function addDeviceToken(DeviceToken $deviceToken): self
    {
        if (!$this->deviceTokens->contains($deviceToken)) {
            $this->deviceTokens[] = $deviceToken;
            $deviceToken->setUser($this);
        }

        return $this;
    }

    public function removeDeviceToken(DeviceToken $deviceToken): self
    {
        if ($this->deviceTokens->contains($deviceToken)) {
            $this->deviceTokens->removeElement($deviceToken);
            // set the owning side to null (unless already changed)
            if ($deviceToken->getUser() === $this) {
                $deviceToken->setUser(null);
            }
        }

        return $this;
    }

    public function getDeletedAt(): ?\DateTimeInterface
    {
        return $this->deletedAt;
    }

    public function setDeletedAt(?\DateTimeInterface $deletedAt): self
    {
        $this->deletedAt = $deletedAt;

        return $this;
    }    

    /* custom methods */

    public function getLastKnownToken(){

        $token = $this->getDeviceTokens()->matching(Criteria::create()->where(Criteria::expr()->eq('active', true))->orderBy(['createdAt' => Criteria::DESC])->setMaxResults(1))->first();

        if($token)
            return $token->getToken();

        return "";

    }

    public function getEmailNotifications(): ?bool
    {
        return $this->emailNotifications;
    }

    public function setEmailNotifications(bool $emailNotifications): self
    {
        $this->emailNotifications = $emailNotifications;

        return $this;
    }

    /**
     * @return Collection|Purchase[]
     */
    public function getPurchases(): Collection
    {
        return $this->purchases;
    }

    public function addPurchase(Purchase $purchase): self
    {
        if (!$this->purchases->contains($purchase)) {
            $this->purchases[] = $purchase;
            $purchase->setUser($this);
        }

        return $this;
    }

    public function removePurchase(Purchase $purchase): self
    {
        if ($this->purchases->contains($purchase)) {
            $this->purchases->removeElement($purchase);
            // set the owning side to null (unless already changed)
            if ($purchase->getUser() === $this) {
                $purchase->setUser(null);
            }
        }

        return $this;
    }

    public function getLanguage(): ?string
    {
        return $this->language;
    }

    public function setLanguage(?string $language): self
    {
        $this->language = $language;

        return $this;
    }

    public function getEmailSentAt(): ?\DateTimeInterface
    {
        return $this->emailSentAt;
    }

    public function setEmailSentAt(?\DateTimeInterface $emailSentAt): self
    {
        $this->emailSentAt = $emailSentAt;

        return $this;
    }

}
