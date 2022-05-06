package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Random;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.IngredientPayload;
import hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads.RecipePayload;
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

    private void saveVideoFromPayload(RecipePayload payload, Recipe recipe) throws FileNotFoundException, IOException {
        if (payload.getVideo() == null)
            return;
        Video newVideo = new Video();
        newVideo.setOrderNumber(0);
        newVideo.setRecipe(recipe);
        newVideo.setLink(fileService.upload(payload.getVideo(),
                "recipe" + recipe.getId() + "_video" + payload.getVideoExtension()));
    }

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
        newRecipe.setDescription(payload.getRecipeDescription());
        newRecipe.setIsApprooved(false);
        return newRecipe;
    }
}
