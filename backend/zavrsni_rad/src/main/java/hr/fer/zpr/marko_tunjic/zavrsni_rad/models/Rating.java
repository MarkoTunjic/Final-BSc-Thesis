package hr.fer.zpr.marko_tunjic.zavrsni_rad.models;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.RatingKey;

@Entity
public class Rating {

    @EmbeddedId
    private RatingKey id = new RatingKey();

    @Column(nullable = false, unique = false)
    private Integer ratingValue;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private Users user;

    @ManyToOne
    @MapsId("recipeId")
    @JoinColumn(name = "recipe_id")
    private Recipe recipe;

    public Rating() {
    }

    public Rating(Integer ratingValue, Users user, Recipe recipe) {
        this.ratingValue = ratingValue;
        this.user = user;
        this.recipe = recipe;
    }

    public RatingKey getId() {
        return id;
    }

    public void setId(RatingKey id) {
        this.id = id;
    }

    public Integer getRatingValue() {
        return ratingValue;
    }

    public void setRatingValue(Integer ratingValue) {
        this.ratingValue = ratingValue;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public Recipe getRecipe() {
        return recipe;
    }

    public void setRecipe(Recipe recipe) {
        this.recipe = recipe;
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
        Rating other = (Rating) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        return true;
    }

}
