package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Filter;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.IngredientPayload;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RecipePayload;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.Recipes;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Image;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Ingredient;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Recipe;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.RecipeStep;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Video;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.ImageRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.IngredientRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeStepRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;

@Service
public class RecipeService {
    @Autowired
    private FileService fileService;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private RecipeStepRepository recipeStepRepository;

    @Autowired
    private ImageRepository imageRepository;

    public static final int RECIPES_PER_PAGE = 10;

    @Transactional
    public Recipe addRecipe(RecipePayload payload) throws FileNotFoundException, IOException {
        Recipe newRecipe = fillRecipeFromPayload(payload);

        Recipe savedRecipe = recipeRepository.save(newRecipe);

        saveIngredientsFromPayload(payload, savedRecipe);
        saveStepsFromPayload(payload, savedRecipe);
        saveImagesFromPayload(payload, savedRecipe);
        saveVideoFromPayload(payload, savedRecipe);

        return savedRecipe;
    }

    @Transactional
    private void saveVideoFromPayload(RecipePayload payload, Recipe recipe) throws FileNotFoundException, IOException {
        if (payload.getVideo() == null)
            return;
        Video newVideo = new Video();
        newVideo.setOrderNumber(0);
        newVideo.setRecipe(recipe);
        newVideo.setLink(fileService.upload(payload.getVideo(),
                "recipe" + recipe.getId() + "_video" + payload.getVideoExtension()));
    }

    @Transactional
    private void saveImagesFromPayload(RecipePayload payload, Recipe recipe) throws FileNotFoundException, IOException {
        int i = 0;
        for (String payloadImage : payload.getImages()) {
            Image newImage = new Image();
            newImage.setOrderNumber(i);
            newImage.setRecipe(recipe);
            newImage.setLink(fileService.upload(payloadImage, "recipe" + recipe.getId() + "_image" + i + ".png"));
            imageRepository.save(newImage);
        }
    }

    @Transactional
    private void saveStepsFromPayload(RecipePayload payload, Recipe recipe) {
        int i = 0;
        for (String step : payload.getSteps()) {
            RecipeStep newStep = new RecipeStep();
            newStep.setRecipe(recipe);
            newStep.setOrderNumber(i);
            newStep.setStepDescription(step);
            recipeStepRepository.save(newStep);
        }
    }

    @Transactional
    private void saveIngredientsFromPayload(RecipePayload payload, Recipe recipe) {
        for (IngredientPayload ingredientPayload : payload.getIngredients()) {
            Ingredient newIngredient = new Ingredient();
            newIngredient.setRecipe(recipe);
            newIngredient.setIngredientName(ingredientPayload.getIngredientName());
            newIngredient.setMeasure(ingredientPayload.getMeasure());
            newIngredient.setQuantity(ingredientPayload.getQuantity());
            ingredientRepository.save(newIngredient);
        }
    }

    private Recipe fillRecipeFromPayload(RecipePayload payload) throws FileNotFoundException, IOException {
        Recipe newRecipe = new Recipe();
        newRecipe.setCookingDuration(payload.getCookingDuration());
        newRecipe.setRecipeName(payload.getRecipeName());
        Users user = usersRepository.getById(payload.getUserId());
        newRecipe.setUser(user);
        String coverPicture;
        if (payload.getCoverPicture() == null)
            coverPicture = FileService.DEFAULT_RECIPE_PICTURE;
        else
            coverPicture = fileService.upload(payload.getCoverPicture(),
                    "recipeImage_" + new Random().nextLong() + ".png");
        newRecipe.setCoverPicture(coverPicture);
        newRecipe.setDescription(payload.getDescription());
        newRecipe.setIsApprooved(false);
        return newRecipe;
    }

    public Recipes getRecipesForFilter(Filter filter) {
        List<Recipe> recipes = recipeRepository.findAll();
        String nameLike = filter.getNameLike() == null ? "" : filter.getNameLike();
        recipes.removeIf(recipe -> hasGreaterCookingDuration(recipe, filter.getMaxCookingDuration())
                || containsForbiddenIngredient(recipe, filter.getMustNotContaintIngredients())
                || !containsAllIngredients(recipe, filter.getCanContainIngredients())
                || !recipe.getRecipeName().contains(nameLike));
        int toIndex = recipes.size() > RECIPES_PER_PAGE ? RECIPES_PER_PAGE : recipes.size();
        recipes = recipes.subList(0, toIndex);
        Double numberOfPages = Math.ceil(recipes.size() * 1.d / RECIPES_PER_PAGE);
        return new Recipes(recipes, numberOfPages.intValue());
    }

    private boolean hasGreaterCookingDuration(Recipe recipe, Integer cookingDuration) {
        if (cookingDuration == null)
            return false;
        return recipe.getCookingDuration() > cookingDuration;
    }

    private boolean containsForbiddenIngredient(Recipe recipe, List<Long> forbiddenIngredients) {
        if (forbiddenIngredients == null)
            return false;
        List<Ingredient> ingredients = ingredientRepository.findByRecipeId(recipe.getId());
        return ingredients.stream().anyMatch(ingredient -> forbiddenIngredients.contains(ingredient.getId()));
    }

    private boolean containsAllIngredients(Recipe recipe, List<Long> requiredIngredients) {
        if (requiredIngredients == null)
            return true;
        List<Ingredient> ingredients = ingredientRepository.findByRecipeId(recipe.getId());
        return ingredients.stream().allMatch(ingredient -> requiredIngredients.contains(ingredient.getId()));
    }

    @Transactional
    public Recipe getById(Long id) {
        return recipeRepository.findById(id).get();
    }
}
