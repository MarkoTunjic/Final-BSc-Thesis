package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.stream.Collectors;

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
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.CommentsRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.FavoriteRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.ImageRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.IngredientRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RatingRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.RecipeStepRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.UsersRepository;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.repositories.VideoRepository;

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

    @Autowired
    private VideoRepository videRepository;

    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private CommentsRepository commentsRepository;

    @Autowired
    private RatingRepository ratingRepository;

    public static final int RECIPES_PER_PAGE = 10;

    @Transactional
    public Recipe addRecipe(RecipePayload payload) throws FileNotFoundException, IOException {
        if (payload.getIngredients().size() <= 0)
            throw new IllegalArgumentException("Must contain at least 1 ingredient");
        if (payload.getSteps().size() <= 0)
            throw new IllegalArgumentException("Must contain at least 1 step");
        if (payload.getCookingDuration() < 0 || payload.getCookingDuration() > 120)
            throw new IllegalArgumentException("Cooking time from 0 to 120");
        if (payload.getDescription().isBlank())
            throw new IllegalArgumentException("Description can not be blank");
        if (payload.getRecipeName().isBlank())
            throw new IllegalArgumentException("Recipe name can not be blank");
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
        if (payload.getVideos() == null)
            return;
        if (payload.getVideoExtensions().size() != payload.getVideos().size())
            throw new IllegalArgumentException("Invalid data format received");
        int i = 0;
        for (String video : payload.getVideos()) {
            Video newVideo = new Video();
            newVideo.setOrderNumber(i);
            newVideo.setRecipe(recipe);
            newVideo.setLink(fileService.upload(video,
                    "recipe" + recipe.getId() + "_video" + i + payload.getVideoExtensions().get(i)));
            videRepository.save(newVideo);
            i++;
        }
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
            i++;
        }
    }

    @Transactional
    private void saveStepsFromPayload(RecipePayload payload, Recipe recipe) {
        int i = 0;
        for (String step : payload.getSteps()) {
            if (step.isBlank())
                throw new IllegalArgumentException("Step can not be blank");
            RecipeStep newStep = new RecipeStep();
            newStep.setRecipe(recipe);
            newStep.setOrderNumber(i);
            newStep.setStepDescription(step);
            recipeStepRepository.save(newStep);
            i++;
        }
    }

    @Transactional
    private void saveIngredientsFromPayload(RecipePayload payload, Recipe recipe) {
        for (IngredientPayload ingredientPayload : payload.getIngredients()) {
            if (ingredientPayload.getIngredientName().isBlank() || ingredientPayload.getMeasure().isBlank()
                    || ingredientPayload.getQuantity() < 0)
                throw new IllegalArgumentException("Invalid ingredient received");
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
        if (filter.getIndex() < 0)
            throw new IllegalArgumentException("Page index can not be less than 0!");
        List<Recipe> recipes;
        String nameLike = filter.getNameLike() == null ? "" : filter.getNameLike().toLowerCase();
        int cookingDuration = filter.getMaxCookingDuration() == null ? Integer.MAX_VALUE
                : filter.getMaxCookingDuration();
        if (filter.getAuthorId() == null)
            recipes = recipeRepository.findByApprovedAndNameLikeAndCookingDuration(nameLike, true,
                    cookingDuration);
        else
            recipes = recipeRepository.findByApprovedAndNameLikeAndCookingDurationAndUserId(nameLike, true,
                    cookingDuration, filter.getAuthorId());

        recipes.removeIf(recipe -> containsForbiddenIngredient(recipe, filter.getMustNotContainIngredients())
                || !containsAllIngredients(recipe, filter.getCanContainIngredients()));
        int toIndex = recipes.size() > RECIPES_PER_PAGE * filter.getIndex() ? RECIPES_PER_PAGE * filter.getIndex()
                : recipes.size();
        recipes = recipes.subList((filter.getIndex() - 1) * RECIPES_PER_PAGE, toIndex);
        Double numberOfPages = Math.ceil(recipes.size() * 1.d / RECIPES_PER_PAGE);

        return new Recipes(recipes, numberOfPages.intValue(), filter.getIndex());
    }

    private boolean containsForbiddenIngredient(Recipe recipe, List<String> forbiddenIngredients) {
        if (forbiddenIngredients == null || forbiddenIngredients.size() == 0)
            return false;
        List<Ingredient> ingredients = ingredientRepository.findByRecipeId(recipe.getId());
        return ingredients.stream().anyMatch(ingredient -> forbiddenIngredients.stream().anyMatch(
                e -> e.equals(ingredient.getIngredientName())));
    }

    private boolean containsAllIngredients(Recipe recipe, List<String> requiredIngredients) {
        if (requiredIngredients == null || requiredIngredients.size() == 0)
            return true;
        List<Ingredient> ingredients = ingredientRepository.findByRecipeId(recipe.getId());
        Set<String> ingredientNames = ingredients.stream().map(ing -> ing.getIngredientName().toLowerCase())
                .collect(Collectors.toCollection(() -> new HashSet<>()));
        Set<String> intersection = requiredIngredients.stream()
                .filter(name -> ingredientNames.contains(name.toLowerCase())).collect(Collectors.toSet());
        return intersection.size() * 1.d / ingredients.size() * 1.d >= 0.6;

        /*
         * return ingredients.stream().allMatch(ingredient ->
         * requiredIngredients.stream().anyMatch(
         * e -> e.equals(ingredient.getIngredientName())));
         */
    }

    @Transactional
    public Recipe getById(Long id) {
        return recipeRepository.findById(id).get();
    }

    @Transactional
    public Boolean deleteRecipe(Long recipeId) throws FileNotFoundException, IOException {
        deleteImagesForRecipe(recipeId);
        deleteVideosForRecipe(recipeId);
        Recipe recipe = recipeRepository.findById(recipeId).get();
        recipeStepRepository.deleteByRecipeId(recipeId);
        ingredientRepository.deleteByRecipeId(recipeId);
        commentsRepository.deleteByRecipeId(recipeId);
        ratingRepository.deleteByRecipeId(recipeId);
        favoriteRepository.deleteByRecipeId(recipeId);
        fileService.delete(recipe.getCoverPicture());
        recipeRepository.deleteById(recipeId);
        return true;
    }

    @Transactional
    private void deleteImagesForRecipe(Long recipeId) throws FileNotFoundException, IOException {
        List<Image> images = imageRepository.findByRecipeId(recipeId);
        for (Image image : images) {
            fileService.delete(image.getLink());
        }
        imageRepository.deleteByRecipeId(recipeId);
    }

    @Transactional
    private void deleteVideosForRecipe(Long recipeId) throws FileNotFoundException, IOException {
        List<Video> videos = videRepository.findByRecipeId(recipeId);
        for (Video video : videos) {
            fileService.delete(video.getLink());
        }
        videRepository.deleteByRecipeId(recipeId);
    }

    @Transactional
    public Boolean changeApprovedStatus(Long recipeId, Boolean approved) {
        Recipe recipe = recipeRepository.findById(recipeId).get();
        recipe.setIsApprooved(approved);
        recipeRepository.save(recipe);
        return true;
    }

    public Recipes getNotApproovedRecipes(Filter filter) {
        String nameLike = filter.getNameLike() == null ? "" : filter.getNameLike();
        List<Recipe> recipes = recipeRepository.getTen((filter.getIndex() - 1) * RECIPES_PER_PAGE, false, nameLike);
        Double numberOfPages = Math
                .ceil(recipeRepository.countByNameAndApprooved(nameLike, false) / (RECIPES_PER_PAGE * 1.d));
        return new Recipes(recipes, numberOfPages.intValue(), filter.getIndex());
    }

    public Recipes getFavorites(Long userId, Filter filter) {
        String nameLike = filter.getNameLike() == null ? "" : filter.getNameLike();
        int cookingDuration = filter.getMaxCookingDuration() == null ? Integer.MAX_VALUE
                : filter.getMaxCookingDuration();

        List<Recipe> recipes = recipeRepository.getFavorites(userId, nameLike, cookingDuration);
        recipes.removeIf(recipe -> containsForbiddenIngredient(recipe, filter.getMustNotContainIngredients())
                || !containsAllIngredients(recipe, filter.getCanContainIngredients()));
        int toIndex = recipes.size() > RECIPES_PER_PAGE * filter.getIndex() ? RECIPES_PER_PAGE * filter.getIndex()
                : recipes.size();
        recipes = recipes.subList((filter.getIndex() - 1) * RECIPES_PER_PAGE, toIndex);
        Double numberOfPages = Math.ceil(recipes.size() * 1.d / RECIPES_PER_PAGE);

        return new Recipes(recipes, numberOfPages.intValue(), filter.getIndex());
    }
}
