package hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class RatingKey implements Serializable {
    @Column(nullable = false, unique = false)
    private Long userId;

    @Column(nullable = false, unique = false)
    private Long recipeId;

    public RatingKey() {
    }

    public RatingKey(Long userID, Long recipeID) {
        this.userId = userID;
        this.recipeId = recipeID;
    }

    public Long getUserID() {
        return userId;
    }

    public void setUserID(Long userID) {
        this.userId = userID;
    }

    public Long getRecipeID() {
        return recipeId;
    }

    public void setRecipeID(Long recipeID) {
        this.recipeId = recipeID;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((recipeId == null) ? 0 : recipeId.hashCode());
        result = prime * result + ((userId == null) ? 0 : userId.hashCode());
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
        RatingKey other = (RatingKey) obj;
        if (recipeId == null) {
            if (other.recipeId != null)
                return false;
        } else if (!recipeId.equals(other.recipeId))
            return false;
        if (userId == null) {
            if (other.userId != null)
                return false;
        } else if (!userId.equals(other.userId))
            return false;
        return true;
    }

}
