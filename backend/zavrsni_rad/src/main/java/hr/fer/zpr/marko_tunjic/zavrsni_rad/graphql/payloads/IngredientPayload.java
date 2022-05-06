package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

public class IngredientPayload {
    private String ingredientName;
    private Integer quantity;
    private String measure;

    public IngredientPayload() {
        super();
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getMeasure() {
        return measure;
    }

    public void setMeasure(String measure) {
        this.measure = measure;
    }

}
