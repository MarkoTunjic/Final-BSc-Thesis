package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import java.util.List;

public class Filter {
    private Long authorId;
    private Integer index;
    private String orderBy;
    private String nameLike;
    private Integer maxCookingDuration;
    private List<String> canContainIngredients;
    private List<String> mustNotContaintIngredients;

    public Filter(Long authorId, Integer index, String orderBy, String nameLike, Integer maxCookingDuration,
            List<String> canContainIngredients, List<String> mustNotContaintIngredients) {
        this.index = index;
        this.orderBy = orderBy;
        this.nameLike = nameLike;
        this.maxCookingDuration = maxCookingDuration;
        this.canContainIngredients = canContainIngredients;
        this.mustNotContaintIngredients = mustNotContaintIngredients;
        this.authorId = authorId;
    }

    public Filter() {
        super();
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    public void setIndex(Integer index) {
        this.index = index;
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

    public List<String> getCanContainIngredients() {
        return canContainIngredients;
    }

    public void setCanContainIngredients(List<String> canContainIngredients) {
        this.canContainIngredients = canContainIngredients;
    }

    public List<String> getMustNotContaintIngredients() {
        return mustNotContaintIngredients;
    }

    public void setMustNotContaintIngredients(List<String> mustNotContaintIngredients) {
        this.mustNotContaintIngredients = mustNotContaintIngredients;
    }

}
