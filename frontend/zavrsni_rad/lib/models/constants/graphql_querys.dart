const String recipes = """
  query Recipes(\$filter: Filter!){
    recipes(filter: \$filter)
    {
      recipes{
        user{
          id,
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
      numberOfPages,
      currentIndex
    }
  }
""";

const String singleRecipe = """
  query SingleRecipe(\$recipeId: ID!){
    singleRecipe(recipeId:\$recipeId){
      id,
      coverPicture,
      recipeName,
      description,
      cookingDuration,
      averageRating,
      user{
        id,
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
        id,
        commentText,
        user{
          username,
          profilePicture
        }
      }
    }
  }
""";
