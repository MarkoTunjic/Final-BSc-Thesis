package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import java.util.List;

public class Filter {
    private int index;
    private String orderBy;
    private String nameLike;
    private Integer maxCookingDuration;
    private List<Long> canContainIngredients;
    private List<Long> mustNotContaintIngredients;

    public Filter(int index, String orderBy, String nameLike, Integer maxCookingDuration,
            List<Long> canContainIngredients, List<Long> mustNotContaintIngredients) {
        this.index = index;
        this.orderBy = orderBy;
        this.nameLike = nameLike;
        this.maxCookingDuration = maxCookingDuration;
        this.canContainIngredients = canContainIngredients;
        this.mustNotContaintIngredients = mustNotContaintIngredients;
    }

    public Filter() {
        super();
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public String getNameLike() {
        return nameLike;
    }

    public void setNameLike(String nameLike) {
        this.nameLike = nameLike;
    }

    public Integer getMaxCookingDuration() {
        return maxCookingDuration;
    }

    public void setMaxCookingDuration(Integer maxCookingDuration) {
        this.maxCookingDuration = maxCookingDuration;
    }

    public List<Long> getCanContainIngredients() {
        return canContainIngredients;
    }

    public void setCanContainIngredients(List<Long> canContainIngredients) {
        this.canContainIngredients = canContainIngredients;
    }

    public List<Long> getMustNotContaintIngredients() {
        return mustNotContaintIngredients;
    }

    public void setMustNotContaintIngredients(List<Long> mustNotContaintIngredients) {
        this.mustNotContaintIngredients = mustNotContaintIngredients;
    }

}
