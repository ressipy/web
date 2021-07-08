let Recipe = {};

Recipe.addIngredient = () => {
  let container = document.getElementById("ingredientsContainer");
  let key = container.getElementsByClassName("ingredientRow").length;

  let row = document.createElement("div");
  row.className = "ingredientRow mt-6 grid grid-cols-4 gap-6";

  let amountContainer = document.createElement("div");
  amountContainer.className = "col-span-1";

  let amountLabel = document.createElement("label");
  amountLabel.className = "block text-sm font-medium text-gray-700";
  amountLabel.htmlFor = `recipe_ingredients_${key}_amount`;
  amountLabel.innerText = "Amount";
  amountContainer.appendChild(amountLabel);

  let amountInput = document.createElement("input");
  amountInput.className =
    "mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm";
  amountInput.id = `recipe_ingredients_${key}_amount`;
  amountInput.name = `recipe[ingredients][${key}][amount]`;
  amountInput.type = "text";
  amountContainer.appendChild(amountInput);

  let orderElement = document.createElement("input");
  orderElement.id = `recipe_ingredients_${key}_order`;
  orderElement.name = `recipe[ingredients][${key}][order]`;
  orderElement.type = "hidden";
  orderElement.value = key + 1;
  amountInput.append(orderElement);

  let nameContainer = document.createElement("div");
  nameContainer.className = "col-span-3";

  let nameLabel = document.createElement("label");
  nameLabel.className = "block text-sm font-medium text-gray-700";
  nameLabel.htmlFor = `recipe_ingredients_${key}_ingredient_name`;
  nameLabel.innerText = "Name";
  nameContainer.appendChild(nameLabel);

  let nameInput = document.createElement("input");
  nameInput.className =
    "mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm";
  nameInput.id = `recipe_ingredients_${key}_ingredient_name`;
  nameInput.name = `recipe[ingredients][${key}][ingredient][name]`;
  nameInput.type = "text";
  nameContainer.appendChild(nameInput);

  row.appendChild(amountContainer);
  row.appendChild(nameContainer);
  container.appendChild(row);
};

Recipe.addInstruction = () => {
  let container = document.getElementById("instructionsContainer");
  let key = container.getElementsByClassName("instructionRow").length;

  let row = document.createElement("div");
  row.className = "instructionRow mt-6";

  let orderElement = document.createElement("input");
  orderElement.id = `recipe_instructions_${key}_order`;
  orderElement.name = `recipe[instructions][${key}][order]`;
  orderElement.type = "hidden";
  orderElement.value = key + 1;
  row.append(orderElement);

  let label = document.createElement("label");
  label.className = "block text-sm font-medium text-gray-700";
  label.htmlFor = `recipe_instructions_${key}_text`;
  label.innerText = `Step ${key + 1}`;
  row.append(label);

  let input = document.createElement("input");
  input.className =
    "mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-red-500 focus:border-red-500 sm:text-sm";
  input.id = `recipe_instructions_${key}_text`;
  input.name = `recipe[instructions][${key}][text]`;
  input.type = "text";
  row.append(input);

  container.appendChild(row);
};

export default Recipe;
