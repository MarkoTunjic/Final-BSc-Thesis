package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import java.util.List;

public class RecipePayload {
    private Long userId;
    private String recipeName;
    private String description;
    private String coverPicture;
    private Integer cookingDuration;
    private List<IngredientPayload> ingredients;
    private List<String> steps;
    private List<String> images;
    private List<String> videos;
    private List<String> videoExtensions;

    public RecipePayload() {
        super();
    }

    public RecipePayload(Long userId, String recipeName, String description, String coverPicture,
            Integer cookingDuration, List<IngredientPayload> ingredients, List<String> steps, List<String> images,
            List<String> video, List<String> videoExtension) {
        this.userId = userId;
        this.recipeName = recipeName;
        this.description = description;
        this.coverPicture = coverPicture;
        this.cookingDuration = cookingDuration;
        this.ingredients = ingredients;
        this.steps = steps;
        this.images = images;
        this.videos = video;
        this.videoExtensions = videoExtension;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
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

    public String getCoverPicture() {
        return coverPicture;
    }

    public void setCoverPicture(String coverPicture) {
        this.coverPicture = coverPicture;
    }

    public Integer getCookingDuration() {
        return cookingDuration;
    }

    public void setCookingDuration(Integer cookingDuration) {
        this.cookingDuration = cookingDuration;
    }

    public List<IngredientPayload> getIngredients() {
        return ingredients;
    }

    public void setIngredients(List<IngredientPayload> ingredients) {
        this.ingredients = ingredients;
    }

    public List<String> getSteps() {
        return steps;
    }

    public void setSteps(List<String> steps) {
        this.steps = steps;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public List<String> getVideos() {
        return videos;
    }

    public void setVideos(List<String> videos) {
        this.videos = videos;
    }

    public List<String> getVideoExtensions() {
        return videoExtensions;
    }

    public void setVideoExtensions(List<String> videoExtensions) {
        this.videoExtensions = videoExtensions;
    }

}
