package hr.fer.zpr.marko_tunjic.zavrsni_rad.models;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Embeddable.CommentsKey;

@Entity
public class Comments {
    @EmbeddedId
    private CommentsKey id;

    @Column(length = 200, nullable = false, unique = false)
    private String commentText;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private Users user;

    @ManyToOne
    @MapsId("recipeId")
    @JoinColumn(name = "recipe_id")
    private Recipe recipe;

    public Comments() {
    }

    public Comments(CommentsKey id, String commentText, Users user, Recipe recipe) {
        this.id = id;
        this.commentText = commentText;
        this.user = user;
        this.recipe = recipe;
    }

    public CommentsKey getId() {
        return id;
    }

    public void setId(CommentsKey id) {
        this.id = id;
    }

    public String getCommentText() {
        return commentText;
    }

    public void setCommentText(String commentText) {
        this.commentText = commentText;
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
        Comments other = (Comments) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        return true;
    }

}
