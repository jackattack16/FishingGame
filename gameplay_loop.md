# Fishing Game

## Loop

### Catching Phase

- Catch 5 fish per round.
- Start with X pieces of bait. You can release a fish to let it swim again.
- The hatchery starts with X fish.
- Each round, you can manipulate the pond by breeding, feeding, or killing fish.
  - Supplies for these actions can be bought in the store between rounds. The store is not accessible during the first round.
- Caught fish are removed from the pond.
  - This encourages future purchases of fish for breeding.
- If the pond does not have enough fish, skip this phase. Someone offers to sell you enough fish to restock the pond.
  - These fish are babies sold at a markup. Their cost is deducted when you sell fish later.
  - The markup could be a percentage or a fixed dollar amount.

### Intermediate Phase

- Once 5 fish are caught, choose whether to refine or sell them.
  - Refine fish to fulfill orders:
    - Cook or slice fish to make them more valuable.
    - Sell to restaurants and other lucrative buyers to fulfill their orders.
  - Sell fish raw:
    - Selling more of one kind could increase their value through economies of scale.
    - Sell to fish merchants or resellers.
    - Raw fish sell for less but require no infrastructure.
- If funds are insufficient, you can take out a loan.
  - Rates are determined by your credit score.
    - The score is based on how often you make payments.
    - More payments lower the interest rates on future loans.
- Purchase chemicals, food, infrastructure, and new fish types to improve the pond.

### Payback Phase

- Choose whether to make payments on debt.
  - You start with $X in debt from buying your parents' old fish hatchery.
    - You do not have to pay off the debt each round.
    - Enough subsequent failures to make payments can result in assets being seized.
    - Eventually, you can go bankrupt.
  - Depending on the loan type, you can choose to pay interest or the principal balance.
- You can invest money for the future.

**Repeat the round.**

## Game Objects

### Fish

- Start with X fish in the pond.
- Purchase new types at various ages.
- Fish mature each round.
  - More mature fish score more points.
- Caught fish are removed from the pond.
  - You will need to restock the pond in the future.
- Fish can breed with the help of species-specific food or be killed with species-specific pesticides.
- Fish can breed naturally, but more slowly.
- Crossbreeding?
  - Physically possible between closely related species.
- Fish can have mutations that make them more valuable.
  - Different metals (gold, silver, bronze).
  - Think of more...
- Fish can become unhealthy. You could put medicine in the pond.

### Refining

- Expensive startup cost and a long repayment period.
- Purchasing refining infrastructure early in the game should require taking on debt.
- Sales depend on market demand.
  - Restaurants might not always want a specific type of fish.
  - Orders are always visible.
- Sign contracts with restaurants to sell a specific type of fish at any time and in any quantity. Fulfill many orders to gain trust.
- Open restaurants and sell to yourself to make a profit.
- Start with a restaurant partnership through a friend of your parents.
  - It should not be useful in the first few rounds unless you happen to catch the right kind of fish.
- Higher-end restaurants want increasingly premium fish.
- Contracts can expire, and selling enough bad fish will damage the relationship.
- Check fish for sickness before selling, provided you have the required infrastructure.

### Pond Modifiers

- Start with a default pond.
- Buy or upgrade machines.
- View the number of fish and basic information about the pond.
- Machines:
  - Clean the water to reduce the number of sick fish.
  - Distract certain types of fish.
  - Breed fish automatically.
  - Provide more advanced pond monitoring:
    - Identify specific fish in the pond.
    - Show health levels.
  - A fountain for algae.
  - Think of more...
- Chemicals:
  - Buy chemicals that may kill specific fish.
  - Closely related fish may also become sick.
  - Chemicals might not kill every fish of the targeted species.
  - Adjust pH for algae?
- Food:
  - Help specific fish types mature, or help all fish mature at once.
  - Encourage breeding for a specific type.
  - Too much food could cause fish to die.
  - Should players be required to buy food?

### Roguelike/Roguelite

- Playing the game unlocks new fish types.
- New fish types allow for more lucrative contracts.
- Upgrades to the starting pond.
- Upgrades to starting restaurants.

### Loans and Debt

- The player starts in debt from buying the property.
- This debt can be repaid on any schedule.
- Take out other loans during the game to finance purchases:
  - Short-term loans:
    - Shorter repayment period, lower interest rate, smaller loan amounts, and higher payments.
  - Long-term loans:
    - Longer repayment period, higher interest rate, larger loan amounts, and lower payments.
    - You can pay only the interest.
  - Family loans:
    - Lowest interest rate, less pressure to repay, and no choice in the amount borrowed. Offers are rare, but players receive a small offer after the first round.
- Loans taken out during the game must be paid off to win.
  - For all loans except family and property loans, you must make a payment each round.
- The amount available to borrow and the interest rate depend on your credit score.
- Defaulting:
  - Short-term and long-term loans:
    - Defaulting reduces your credit score.
    - After X defaults, assets can be seized.
  - Family loans:
    - You can default a couple of times.
    - A family member may then demand a percentage of profits until the loan is repaid.
- Specific items may have 0% financing, such as machines during a lucky sale.

**The game ends when the player pays off all debts.**

- You can keep playing afterward to see how much money you can make.
- In free play, you need to fulfill orders to stay in business.
- Competitors enter your market and try to undercut your prices.
- You need to stay competitive.
