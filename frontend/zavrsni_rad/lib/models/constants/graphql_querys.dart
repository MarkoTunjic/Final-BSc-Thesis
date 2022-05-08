const String recipes = """
  query Recipes(\$filter: Filter!){
    recipes(filter: \$filter)
    {
      recipes{
        user{
          username,
          profilePicture
        }
        id,
        averageRating,
        cookingDuration,
        coverPicture,
        recipeName,
        isLikedByCurrentUser
      }
      numberOfPages
    }
  }
""";

const String singleRecipe = """
  query SingleRecipe(\$recipeId: ID!){
    singleRecipe(recipeId:\$recipeId){
      coverPicture,
      recipeName,
      description,
      cookingDuration,
      averageRating,
      user{
        username,
        profilePicture
      }
      ingredients{
        ingredientName,
        quantity,
        measure
      }
      recipeSteps{
        orderNumber,
        stepDescription
      }
      images{
        link
      }
      videos{
        link
      }
      comments{
        commentText,
        user{
          username,
          profilePicture
        }
      }
    }
  }
""";
