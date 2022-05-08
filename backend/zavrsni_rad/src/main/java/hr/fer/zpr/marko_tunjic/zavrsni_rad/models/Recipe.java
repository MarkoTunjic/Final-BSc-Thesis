package hr.fer.zpr.marko_tunjic.zavrsni_rad.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
public class Recipe {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(length = 100, nullable = false, unique = false)
    private String coverPicture;

    @Column(length = 50, nullable = false, unique = false)
    private String recipeName;

    @Column(length = 500, nullable = false, unique = false)
    private String description;

    @Column(nullable = false, unique = false)
    private Boolean isApprooved;

    @Column(nullable = false, unique = false)
    private Integer cookingDuration;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private Users user;

    public Recipe() {

    }

    public Recipe(String coverPicture, String recipeName, String description, Boolean isApprooved,
            Integer cookingDuration, Users user) {
        this.coverPicture = coverPicture;
        this.recipeName = recipeName;
        this.description = description;
        this.isApprooved = isApprooved;
        this.cookingDuration = cookingDuration;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCoverPicture() {
        return coverPicture;
    }

    public void setCoverPicture(String coverPicture) {
        this.coverPicture = coverPicture;
    }

    public String getRecipeName() {
        return recipeName;
    }

    public void setRecipeName(String recipeName) {
        this.recipeName = recipeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsApprooved() {
        return isApprooved;
    }

    public void setIsApprooved(Boolean isApprooved) {
        this.isApprooved = isApprooved;
    }

    public Integer getCookingDuration() {
        return cookingDuration;
    }

    public void setCookingDuration(Integer cookingDuration) {
        this.cookingDuration = cookingDuration;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Recipe other = (Recipe) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        return true;
    }

}
