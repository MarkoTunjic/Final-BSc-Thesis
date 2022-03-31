package hr.fer.zpr.marko_tunjic.zavrsni_rad.models;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

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
    private String isApprooved;

    @Column(nullable = false, unique = false)
    private Integer cookingDuration;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private Users user;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<RecipeStep> recipeSteps;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Ingredient> ingredients;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Image> images;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Rating> ratings;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Comments> comments;

    @JsonIgnore
    @OneToMany(mappedBy = "recipe", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Favorite> favoriteTo;

    public Recipe() {
        this.recipeSteps = new HashSet<>();
        this.ingredients = new HashSet<>();
        this.images = new HashSet<>();
        this.ratings = new HashSet<>();
        this.comments = new HashSet<>();
        this.favoriteTo = new HashSet<>();
    }

    public Recipe(String coverPicture, String recipeName, String description, String isApprooved,
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

    public String getIsApprooved() {
        return isApprooved;
    }

    public void setIsApprooved(String isApprooved) {
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

    public Set<RecipeStep> getRecipeSteps() {
        return recipeSteps;
    }

    public void setRecipeSteps(Set<RecipeStep> recipeSteps) {
        this.recipeSteps = recipeSteps;
    }

    public Set<Ingredient> getIngredients() {
        return ingredients;
    }

    public void setIngredients(Set<Ingredient> ingredients) {
        this.ingredients = ingredients;
    }

    public Set<Image> getImages() {
        return images;
    }

    public void setImages(Set<Image> images) {
        this.images = images;
    }

    public Set<Rating> getRatings() {
        return ratings;
    }

    public void setRatings(Set<Rating> ratings) {
        this.ratings = ratings;
    }

    public Set<Comments> getComments() {
        return comments;
    }

    public void setComments(Set<Comments> comments) {
        this.comments = comments;
    }

    public Set<Favorite> getFavoriteTo() {
        return favoriteTo;
    }

    public void setFavoriteTo(Set<Favorite> favoriteTo) {
        this.favoriteTo = favoriteTo;
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
