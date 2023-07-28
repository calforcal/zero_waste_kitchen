require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end

  describe 'instance methods' do
    let!(:user_1) { User.create!(uid: "123", name: "Michael C", email: "michael@gmail.com") }

    let!(:recipe_1) { Recipe.create!(name: 'Chicken Parm', instructions: ['1. Cook the chicken', '2. Cover in sauce and cheese', '3. Enjoy!'], image_url: 'pic of my chicken parm', api_rating: 99.99, cook_time: 45, public_status: true, source_name: user_1.name, source_url: "/api/v1/users/#{user_1.id}") }
    let!(:chicken) { Ingredient.create!(name: 'Chicken', units: 2.0, unit_type: 'lbs') }
    let!(:cheese) { Ingredient.create!(name: 'Cheese', units: 0.5, unit_type: 'lbs') }
    let!(:recipe_ingredients_1) { recipe_1.recipe_ingredients.create!(ingredient_id: chicken.id) }
    let!(:recipe_ingredients_2) { recipe_1.recipe_ingredients.create!(ingredient_id: cheese.id) }

    let!(:recipe_2) { Recipe.create!(name: 'Meatballs', instructions: ['1. Cook the meatballs', '2. Cover in sauce', '3. Eat!'], image_url: 'meatballs path', api_rating: 22.22, cook_time: 22, public_status: true, source_name: 'Italian Chef', source_url: 'Italian Chef Web') }
    let!(:ground_beef) { Ingredient.create!(name: 'ground beef', units: 2.0, unit_type: 'lbs') }
    let!(:eggs) { Ingredient.create!(name: 'eggs', units: 2.0, unit_type: 'oz') }
    let!(:recipe_ingredients_3) { recipe_1.recipe_ingredients.create!(ingredient_id: ground_beef.id) }
    let!(:recipe_ingredients_4) { recipe_1.recipe_ingredients.create!(ingredient_id: eggs.id) }

    let!(:recipe_3) { Recipe.create!(name: 'Pasta', instructions: ['1. Cook Pasta', '2. Cover in butter and cheese', '3. Yum!'], image_url: 'yummy pasta url', api_rating: 100.00, cook_time: 10, public_status: true, source_name: 'Italian Chef', source_url: 'Italian Chef Web') }
    let!(:pasta) { Ingredient.create!(name: 'pasta', units: 1.0, unit_type: 'lbs') }
    let!(:butter) { Ingredient.create!(name: 'butter', units: 2, unit_type: 'oz') }
    let!(:recipe_ingredients_5) { recipe_1.recipe_ingredients.create!(ingredient_id: pasta.id) }
    let!(:recipe_ingredients_6) { recipe_1.recipe_ingredients.create!(ingredient_id: butter.id) }

    let!(:user_recipe_1) { user_1.user_recipes.create!(recipe_id: recipe_1.id, num_stars: 4, cook_status: false, saved_status: true, is_owner: true) }
    let!(:user_recipe_2) { user_1.user_recipes.create!(recipe_id: recipe_2.id, num_stars: 5, cook_status: true, saved_status: true, is_owner: false) }

    let!(:saved_ingredient_1) { user_1.saved_ingredients.create!(ingredient_name: chicken.name, unit_type: chicken.unit_type, units: chicken.units)}
    let!(:saved_ingredient_2) { user_1.saved_ingredients.create!(ingredient_name: cheese.name, unit_type: cheese.unit_type, units: cheese.units)}
    let!(:saved_ingredient_3) { user_1.saved_ingredients.create!(ingredient_name: ground_beef.name, unit_type: ground_beef.unit_type, units: ground_beef.units)}
    let!(:saved_ingredient_4) { user_1.saved_ingredients.create!(ingredient_name: eggs.name, unit_type: eggs.unit_type, units: eggs.units)}

    describe '#emissions_reduction' do
      it 'can return the total value of emissions reduced from saved ingredients', :vcr do
        expect(user_1.emissions_reduction).to eq(14.136868307551117)
      end
    end

    describe '#num_recipes_cooked' do
      it 'can return the number of recipes a user as cooked' do
        expect(Recipe.all.count).to eq(3)
        expect(user_1.recipes.count).to eq(2)

        expect(user_1.num_recipes_cooked).to eq(1)
      end
    end

    describe '#num_recipes_created' do
      it 'can return the number of recipes a user has created' do
        expect(Recipe.all.count).to eq(3)
        expect(user_1.recipes.count).to eq(2)

        expect(user_1.num_recipes_created).to eq(1)
      end
    end

    describe '#user_stats' do
      it 'can return a condensed version of all user stats', :vcr do
        expect(user_1.user_stats).to eq({
          recipes_created: 1,
          recipes_cooked: 1,
          kg_emissions_saved: 14.14
        })
      end
    end

    describe '#recipes_cooked' do
      it 'can return the number of recipes a user as cooked' do
        expect(Recipe.all.count).to eq(3)
        expect(user_1.recipes.count).to eq(2)

        expect(user_1.recipes_cooked.count).to eq(1)
        expect(user_1.recipes_cooked.first.id).to eq(recipe_2.id)
        expect(user_1.recipes_cooked.first.name).to eq(recipe_2.name)
      end
    end

    describe '#recipes_created' do
      it 'can return the number of recipes a user has created' do
        expect(Recipe.all.count).to eq(3)
        expect(user_1.recipes.count).to eq(2)

        expect(user_1.recipes_created.count).to eq(1)
        expect(user_1.recipes_created.first.id).to eq(recipe_1.id)
        expect(user_1.recipes_created.first.name).to eq(recipe_1.name)
      end
    end
  end
end
