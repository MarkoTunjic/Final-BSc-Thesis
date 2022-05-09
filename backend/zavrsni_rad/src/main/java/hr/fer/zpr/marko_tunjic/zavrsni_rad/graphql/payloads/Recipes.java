package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import java.util.List;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;

public class Recipes {
    private List<Recipe> recipes;
    private Integer numberOfPages;
    private Integer currentIndex;

    public Recipes(List<Recipe> recipes, Integer numberOfPages, Integer currentIndex) {
        this.recipes = recipes;
        this.numberOfPages = numberOfPages;
        this.currentIndex = currentIndex;
    }

    public Integer getCurrentIndex() {
        return currentIndex;
    }

    public void setCurrentIndex(Integer currentIndex) {
        this.currentIndex = currentIndex;
    }

    public Recipes() {
        super();
    }

    public List<Recipe> getRecipes() {
        return recipes;
    }

    public void setRecipes(List<Recipe> recipes) {
        this.recipes = recipes;
    }

    public Integer getNumberOfPages() {
        return numberOfPages;
    }

    public void setNumberOfPages(Integer numberOfPages) {
        this.numberOfPages = numberOfPages;
    }

}
