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
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(length = 50, nullable = false, unique = true)
    private String username;

    @Column(length = 100, nullable = false, unique = true)
    private String eMail;

    @Column(length = 60, nullable = false, unique = false)
    private String password;

    @Column(length = 100, nullable = false, unique = false)
    private String profilePicture;

    @Column(nullable = false, unique = false)
    private boolean isBanned;

    @Column(nullable = false, unique = false)
    private boolean isConfirmed;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    @JsonIgnore
    @OneToMany(mappedBy = "user", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Recipe> recipes;

    @JsonIgnore
    @OneToMany(mappedBy = "user", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Rating> ratings;

    @JsonIgnore
    @OneToMany(mappedBy = "user", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Comments> comments;

    @JsonIgnore
    @OneToMany(mappedBy = "user", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<Favorite> favorites;

    public Users() {
        this.recipes = new HashSet<>();
        this.ratings = new HashSet<>();
        this.comments = new HashSet<>();
        this.favorites = new HashSet<>();
    }

    public Users(String username, String eMail, String password, String profilePicture, boolean isBanned,
            boolean isConfirmed, Role role) {
        this.username = username;
        this.eMail = eMail;
        this.password = password;
        this.profilePicture = profilePicture;
        this.isBanned = isBanned;
        this.isConfirmed = isConfirmed;
        this.role = role;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String geteMail() {
        return eMail;
    }

    public void seteMail(String eMail) {
        this.eMail = eMail;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public boolean isBanned() {
        return isBanned;
    }

    public void setBanned(boolean isBanned) {
        this.isBanned = isBanned;
    }

    public boolean isConfirmed() {
        return isConfirmed;
    }

    public void setConfirmed(boolean isConfirmed) {
        this.isConfirmed = isConfirmed;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Set<Recipe> getRecipes() {
        return recipes;
    }

    public void setRecipes(Set<Recipe> recipes) {
        this.recipes = recipes;
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

    public Set<Favorite> getFavorites() {
        return favorites;
    }

    public void setFavorites(Set<Favorite> favorites) {
        this.favorites = favorites;
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
        Users other = (Users) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        return true;
    }
}
