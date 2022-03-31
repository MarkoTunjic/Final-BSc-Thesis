package hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class FavoriteKey implements Serializable {
    @Column(nullable = false, unique = false)
    private Long userId;

    @Column(nullable = false, unique = false)
    private Long recipeId;

    public FavoriteKey() {
    }

    public FavoriteKey(Long userId, Long recipeId) {
        this.userId = userId;
        this.recipeId = recipeId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getRecipeId() {
        return recipeId;
    }

    public void setRecipeId(Long recipeId) {
        this.recipeId = recipeId;
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
        FavoriteKey other = (FavoriteKey) obj;
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
