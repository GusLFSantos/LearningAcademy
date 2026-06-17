# Idempotent seed data for LearningAcademy.
#   bin/rails db:seed        — fill in / top up content
#   bin/rails db:reset       — drop, recreate, and reseed from scratch
#
# Creates a few demo learners and two fully-formed courses (Markdown lessons
# with fenced code + Mermaid diagrams, a quiz per lesson, and a course badge).

# ---------------------------------------------------------------------------
# Learners (no auth yet — the app resolves a current_user from these)
# ---------------------------------------------------------------------------
[
  [ "Demo Learner", "demo@learningacademy.test" ],
  [ "Ada Lovelace", "ada@learningacademy.test" ],
  [ "Grace Hopper", "grace@learningacademy.test" ]
].each do |name, email|
  User.find_or_create_by!(email: email) { |u| u.name = name }
end

# ---------------------------------------------------------------------------
# Lesson bodies (Markdown). Single-quoted heredocs so `#{}` in code is literal.
# ---------------------------------------------------------------------------
ruby_variables = <<~'MD'
  ## Variables and Types

  Ruby is **dynamically typed** — you don't declare types, you just assign.

  ```ruby
  name = "Ada"      # String
  age  = 36         # Integer
  pi   = 3.14159    # Float
  puts "#{name} is #{age}"
  ```

  Everything is an object, even numbers:

  ```ruby
  42.class      # => Integer
  "hi".upcase   # => "HI"
  ```

  > Tip: use `#{}` to interpolate inside double-quoted strings.
MD

ruby_methods = <<~'MD'
  ## Methods and Blocks

  Define behaviour with `def`, and pass reusable chunks of code as **blocks**.

  ```ruby
  def greet(name)
    "Hello, #{name}!"
  end

  [1, 2, 3].each { |n| puts n * 2 }
  ```

  How a block flows through a method:

  ```mermaid
  flowchart LR
    A[Call method] --> B[yield to block]
    B --> C[Block runs]
    C --> D[Return to method]
  ```
MD

ruby_collections = <<~'MD'
  ## Collections

  Two workhorses: **Arrays** (ordered) and **Hashes** (key/value).

  ```ruby
  langs = ["Ruby", "Python", "Go"]
  langs.map(&:upcase)          # => ["RUBY", "PYTHON", "GO"]

  scores = { ada: 95, grace: 99 }
  scores[:grace]               # => 99
  ```

  Enumerable methods like `map`, `select`, and `reduce` make data easy to work with.
MD

git_what = <<~'MD'
  ## What is Git?

  Git is a **distributed version control system** — it tracks changes to your
  files so you can review history and collaborate safely.

  The three areas your files move through:

  ```mermaid
  flowchart LR
    W[Working dir] -->|git add| S[Staging area]
    S -->|git commit| R[Repository]
  ```

  Check the state of those areas any time with:

  ```bash
  git status
  ```
MD

git_commits = <<~'MD'
  ## Commits and Branches

  A **commit** is a snapshot. A **branch** is a movable pointer to a commit, so
  you can develop features in isolation.

  ```bash
  git checkout -b feature/login
  git add .
  git commit -m "Add login form"
  ```

  ```mermaid
  gitGraph
    commit
    branch feature
    commit
    checkout main
    commit
    merge feature
  ```
MD

git_remotes = <<~'MD'
  ## Remotes and Pushing

  A **remote** is a shared copy of your repo (e.g. on GitHub). Push local commits
  up, and pull others' work down.

  ```bash
  git remote add origin git@github.com:you/repo.git
  git push -u origin main
  git pull
  ```

  > `origin` is just the conventional name for your default remote.
MD

# ---------------------------------------------------------------------------
# JavaScript Fundamentals — lesson bodies
# ---------------------------------------------------------------------------

js_variables = <<~'MD'
  ## Variables, Types, and Scope

  JavaScript gives you three ways to declare a variable. Choosing the right
  one is not a matter of taste — it has concrete consequences for your code.

  ### `var`, `let`, and `const`

  ```javascript
  var   name = "Ada";   // function-scoped, hoisted — avoid in modern JS
  let   age  = 36;      // block-scoped, can be reassigned
  const PI   = 3.14159; // block-scoped, cannot be reassigned
  ```

  **Prefer `const` by default.** Reach for `let` only when you genuinely
  need to reassign. Treat `var` as a historical artefact.

  #### Why `var` is problematic

  `var` is *function-scoped*, meaning it ignores block boundaries like `if`
  and `for`. Worse, it is *hoisted* — the declaration is silently moved to
  the top of its function, which makes code behave in surprising ways:

  ```javascript
  console.log(x); // undefined — not an error! var is hoisted
  var x = 5;

  if (true) {
    var leaky = "I escape the block";
  }
  console.log(leaky); // "I escape the block" — oops
  ```

  `let` and `const` are block-scoped and are **not** accessible before their
  declaration (the "temporal dead zone"), so bugs surface as errors rather
  than silent `undefined` values.

  ### The Seven Primitive Types

  Everything that is *not* an object in JavaScript is a primitive:

  | Type        | Example                       | `typeof` result  |
  |-------------|-------------------------------|------------------|
  | `string`    | `"hello"`, `'world'`          | `"string"`       |
  | `number`    | `42`, `3.14`, `NaN`, `Infinity` | `"number"`     |
  | `boolean`   | `true`, `false`               | `"boolean"`      |
  | `undefined` | unassigned variables          | `"undefined"`    |
  | `null`      | intentional absence of value  | `"object"` ⚠️   |
  | `bigint`    | `9007199254740991n`           | `"bigint"`       |
  | `symbol`    | `Symbol("id")`                | `"symbol"`       |

  > **`typeof null === "object"` is a famous bug** inherited from the very
  > first version of JavaScript. It has never been fixed because doing so
  > would break too much of the web. Always check for `null` explicitly.

  ### Equality: `==` vs `===`

  This is one of the most important rules to internalise:

  ```javascript
  // == performs type coercion — full of surprises
  0   == "0"   // true  (number vs string)
  0   == false // true  (number vs boolean)
  ""  == false // true
  null == undefined // true

  // === checks value AND type — no coercion
  0   === "0"   // false ✓
  0   === false // false ✓
  ```

  **Always use `===` and `!==`.** The only exception some engineers allow is
  `x == null`, which catches both `null` and `undefined` in one check.

  ### Template Literals

  Template literals (backtick strings) are the modern way to build strings:

  ```javascript
  const user  = "Grace";
  const score = 99;

  // Old way — error-prone concatenation
  const msg1 = "Hello, " + user + ". You scored " + score + ".";

  // New way — readable and safe
  const msg2 = `Hello, ${user}. You scored ${score}.`;

  // Multi-line — no \n needed
  const html = `
    <p class="score">
      ${user}: ${score}
    </p>
  `;
  ```
MD

js_functions = <<~'MD'
  ## Functions — JavaScript's First-Class Citizens

  In JavaScript, functions are *values*. You can store them in variables,
  pass them as arguments, and return them from other functions. This single
  fact underlies most of JavaScript's expressive power.

  ### Three Ways to Define a Function

  ```javascript
  // 1. Function Declaration — hoisted, visible throughout its scope
  function add(a, b) {
    return a + b;
  }

  // 2. Function Expression — not hoisted, assigned like any value
  const multiply = function(a, b) {
    return a * b;
  };

  // 3. Arrow Function — concise, and crucially: no own `this`
  const divide = (a, b) => a / b;
  ```

  Arrow functions with a single expression can omit the braces and `return`:

  ```javascript
  const square = x => x * x;          // one parameter, one expression
  const greet  = () => "Hello!";       // no parameters
  const add3   = (a, b, c) => a+b+c;  // multiple parameters need parens
  ```

  ### Hoisting: Why It Matters

  Function *declarations* are fully hoisted — you can call them before they
  appear in the file. Function *expressions* and arrow functions are not:

  ```javascript
  sayHello();          // works fine — declaration is hoisted
  // sayBye();         // ReferenceError — expression is not hoisted

  function sayHello()  { console.log("Hello!"); }
  const   sayBye    =  () => console.log("Bye!");
  ```

  ### Default, Rest, and Spread Parameters

  ```javascript
  // Default parameters — used when argument is undefined
  function greet(name = "stranger") {
    return `Hello, ${name}!`;
  }
  greet("Ada");   // "Hello, Ada!"
  greet();        // "Hello, stranger!"

  // Rest parameters — gathers remaining args into an array
  function sum(...numbers) {
    return numbers.reduce((total, n) => total + n, 0);
  }
  sum(1, 2, 3, 4); // 10

  // Spread — expands an array into individual arguments
  const nums = [1, 2, 3];
  Math.max(...nums); // 3
  ```

  ### Higher-Order Functions and Callbacks

  A **higher-order function** takes a function as an argument or returns
  one. This pattern is everywhere in JavaScript:

  ```javascript
  // setTimeout takes a callback — a function to call later
  setTimeout(() => console.log("1 second later"), 1000);

  // Array methods take callbacks
  const numbers = [1, 2, 3, 4, 5];
  const evens   = numbers.filter(n => n % 2 === 0); // [2, 4]
  const doubled = numbers.map(n => n * 2);           // [2, 4, 6, 8, 10]
  ```

  ### Closures

  A **closure** is a function that *remembers* the variables from the scope
  where it was created, even after that scope has finished executing.

  ```javascript
  function makeCounter() {
    let count = 0;          // this variable is "closed over"
    return function() {
      count += 1;
      return count;
    };
  }

  const counter = makeCounter();
  counter(); // 1
  counter(); // 2
  counter(); // 3 — count persists between calls
  ```

  Closures are the mechanism behind module patterns, memoization, and most
  of JavaScript's encapsulation patterns.

  ### Pure Functions and Side Effects

  A **pure function** always returns the same output for the same input, and
  produces no *side effects* (no mutation, no I/O, no network calls).

  ```javascript
  // Pure — predictable, easy to test
  const add = (a, b) => a + b;

  // Impure — reads external state, result is unpredictable
  let tax = 0.2;
  const priceWithTax = amount => amount * (1 + tax);
  ```

  Write pure functions wherever possible. Reserve side effects for explicit,
  clearly-named functions at the edges of your program.
MD

js_objects = <<~'MD'
  ## Objects, Classes, and the Mystery of `this`

  Objects are the primary data structure in JavaScript. Understanding how
  they relate to each other through the **prototype chain** — and how `this`
  is determined at call time — unlocks the entire language.

  ### Object Literals

  The simplest way to create an object:

  ```javascript
  const person = {
    name:  "Ada Lovelace",
    born:  1815,
    greet() {                          // method shorthand
      return `I am ${this.name}.`;
    }
  };

  person.name;            // "Ada Lovelace"  — dot notation
  person["born"];         // 1815            — bracket notation
  person.greet();         // "I am Ada Lovelace."
  ```

  ### Destructuring

  Destructuring extracts values into named variables without repetition:

  ```javascript
  const { name, born } = person;
  console.log(name); // "Ada Lovelace"

  // With renaming and defaults
  const { name: fullName, title = "Engineer" } = person;

  // Array destructuring
  const [first, second, ...rest] = [10, 20, 30, 40];
  // first = 10, second = 20, rest = [30, 40]

  // In function parameters
  function display({ name, born }) {
    console.log(`${name} (${born})`);
  }
  ```

  ### The Prototype Chain

  Every object in JavaScript has a hidden link to a *prototype* object. When
  you access a property, the engine first looks on the object itself, then
  walks up the chain:

  ```mermaid
  flowchart TD
    A["myArray [ ]"] -->|".__proto__"| B["Array.prototype\n(push, map, filter…)"]
    B -->|".__proto__"| C["Object.prototype\n(toString, hasOwnProperty…)"]
    C -->|".__proto__"| D["null — end of chain"]
  ```

  This is why `[].push(1)` works even though you never defined `push` — it
  lives on `Array.prototype`, shared by every array.

  ### ES6 Classes

  Classes are **syntactic sugar** over prototype-based inheritance. They make
  the familiar object-oriented style available without hiding the prototype
  mechanism:

  ```javascript
  class Animal {
    constructor(name) {
      this.name = name;          // instance property
    }

    speak() {                    // prototype method — shared by all instances
      return `${this.name} makes a noise.`;
    }
  }

  class Dog extends Animal {
    speak() {
      return `${this.name} barks.`;  // overrides Animal#speak
    }
  }

  const d = new Dog("Rex");
  d.speak();           // "Rex barks."
  d instanceof Dog;    // true
  d instanceof Animal; // true — prototype chain includes Animal
  ```

  ### `this` — The Most Confusing Concept in JavaScript

  Unlike most languages, `this` in JavaScript is **not** determined by where
  a function is *defined* — it is determined by *how* it is *called*:

  ```javascript
  const obj = {
    value: 42,
    regular: function() { return this.value; },   // this = obj ✓
    arrow:   ()        => this.value              // this = outer scope ✗
  };

  obj.regular(); // 42
  obj.arrow();   // undefined — arrows capture the surrounding this

  // Losing context when passing a method as a callback
  const fn = obj.regular;
  fn();          // undefined — called as a plain function, not a method
  fn.call(obj);  // 42       — .call() explicitly sets this
  ```

  **Rule of thumb:** Arrow functions inherit `this` from the enclosing scope
  at *definition* time. Use them inside class methods or callbacks where you
  want to preserve the outer `this`. Use regular functions when you need the
  call-site `this` — i.e., in object methods.

  ### Spread and Object Composition

  The spread operator `...` copies properties — the idiomatic way to produce
  updated objects without mutating the original:

  ```javascript
  const defaults = { theme: "light", language: "en", fontSize: 16 };
  const userPrefs = { language: "pt", fontSize: 18 };

  // Later properties win — userPrefs overrides defaults
  const config = { ...defaults, ...userPrefs };
  // { theme: "light", language: "pt", fontSize: 18 }

  // Add or override a single property immutably
  const darkMode = { ...config, theme: "dark" };
  ```
MD

js_arrays = <<~'MD'
  ## Arrays and the Functional Toolkit

  Arrays are ordered, zero-indexed collections. JavaScript's array methods —
  especially `map`, `filter`, and `reduce` — let you transform data
  declaratively, expressing *what* you want rather than *how* to get it.

  ### Creating and Accessing Arrays

  ```javascript
  const fruits = ["apple", "banana", "cherry"];

  fruits[0];             // "apple"
  fruits[fruits.length - 1]; // "cherry" — last element
  fruits.at(-1);         // "cherry" — modern shorthand

  // Spread to copy (avoid mutating the original)
  const moreFruits = [...fruits, "date"];
  ```

  ### Mutating vs Non-Mutating Operations

  This distinction will save you hours of debugging:

  | Mutates the array        | Returns a new array / value  |
  |--------------------------|------------------------------|
  | `push`, `pop`            | `map`, `filter`, `reduce`    |
  | `splice`, `sort`, `reverse` | `slice`, `concat`         |
  | `shift`, `unshift`       | `find`, `findIndex`          |

  When working with React, Redux, or any framework that tracks changes by
  reference, always prefer the non-mutating forms.

  ### `map` — Transform Every Element

  `map` applies a function to each element and returns a **new array** of the
  same length:

  ```javascript
  const prices  = [10, 25, 8, 42];
  const doubled = prices.map(p => p * 2);   // [20, 50, 16, 84]
  const labels  = prices.map(p => `$${p}`); // ["$10", "$25", "$8", "$42"]
  ```

  ### `filter` — Keep Elements That Pass a Test

  `filter` returns a new array containing only the elements for which the
  callback returns `true`:

  ```javascript
  const scores  = [45, 82, 67, 91, 38, 76];
  const passing = scores.filter(s => s >= 70); // [82, 91, 76]
  ```

  ### `reduce` — Fold an Array into a Single Value

  `reduce` is the most powerful — and most misunderstood — array method.
  It accumulates a running result by calling a function on each element:

  ```javascript
  // Sum
  const total = [1, 2, 3, 4].reduce((acc, n) => acc + n, 0); // 10

  // Group by category
  const items = [
    { name: "apple",  type: "fruit" },
    { name: "carrot", type: "veg"   },
    { name: "banana", type: "fruit" }
  ];

  const byType = items.reduce((groups, item) => {
    const key = item.type;
    groups[key] = groups[key] || [];
    groups[key].push(item.name);
    return groups;
  }, {});
  // { fruit: ["apple", "banana"], veg: ["carrot"] }
  ```

  ### `find`, `some`, `every`

  ```javascript
  const users = [
    { name: "Ada",   admin: true  },
    { name: "Grace", admin: false },
    { name: "Alan",  admin: false }
  ];

  // find — returns the first matching element, or undefined
  users.find(u => u.admin);          // { name: "Ada", admin: true }

  // some — true if at least one passes
  users.some(u => u.admin);          // true

  // every — true if ALL pass
  users.every(u => u.admin);         // false
  ```

  ### Chaining for Readability

  Because these methods return arrays, you can chain them. This reads almost
  like a sentence:

  ```javascript
  const orders = [
    { product: "Laptop",  price: 1200, shipped: true  },
    { product: "Mouse",   price:   35, shipped: false },
    { product: "Monitor", price:  450, shipped: true  },
    { product: "Desk",    price:  300, shipped: false }
  ];

  const shippedTotal = orders
    .filter(o => o.shipped)
    .map(o => o.price)
    .reduce((sum, p) => sum + p, 0);
  // 1650
  ```

  A chain is a pipeline: `filter` narrows the array, `map` transforms it,
  `reduce` folds it. Each step is independently readable and testable.

  ### Sorting

  `sort` sorts **in place** and coerces elements to strings by default —
  which produces wrong results for numbers:

  ```javascript
  [10, 9, 2, 1, 100].sort();            // [1, 10, 100, 2, 9] — wrong!
  [10, 9, 2, 1, 100].sort((a, b) => a - b); // [1, 2, 9, 10, 100] ✓

  // Sort strings alphabetically
  ["banana", "apple", "cherry"].sort((a, b) => a.localeCompare(b));
  ```

  Always pass a comparator to `sort` unless you are certain you have an
  array of single-character strings.
MD

js_dom = <<~'MD'
  ## The DOM and Event-Driven Programming

  The **Document Object Model** is the browser's live, in-memory
  representation of your HTML page. Every element, attribute, and text
  node is an object you can read and manipulate with JavaScript.

  ### What the DOM Looks Like

  Given this HTML:

  ```html
  <main id="app">
    <h1 class="title">Hello</h1>
    <button id="btn">Click me</button>
  </main>
  ```

  The browser builds a tree:

  ```mermaid
  flowchart TD
    document --> html
    html --> body
    body --> main["main#app"]
    main --> h1["h1.title\n'Hello'"]
    main --> button["button#btn\n'Click me'"]
  ```

  ### Selecting Elements

  ```javascript
  // querySelector — CSS selector syntax, returns first match (or null)
  const title  = document.querySelector(".title");
  const btn    = document.querySelector("#btn");

  // querySelectorAll — returns a NodeList (array-like)
  const all_h2 = document.querySelectorAll("h2");
  [...all_h2].forEach(el => console.log(el.textContent));

  // The classics (still useful for IDs)
  const app = document.getElementById("app");
  ```

  ### Reading and Updating the DOM

  ```javascript
  // Read
  title.textContent;          // "Hello"
  btn.getAttribute("id");     // "btn"
  btn.classList.contains("active"); // false

  // Update
  title.textContent = "Hello, Ada!";
  title.style.color = "indigo";
  btn.classList.add("primary");
  btn.setAttribute("disabled", "");

  // Create and append
  const p = document.createElement("p");
  p.textContent = "New paragraph.";
  document.querySelector("main").appendChild(p);
  ```

  ### Events and `addEventListener`

  Interactivity in the browser is entirely event-driven. Your code
  *reacts* to things that happen — clicks, form submissions, keystrokes.

  ```javascript
  btn.addEventListener("click", function(event) {
    console.log("Clicked!", event.target);
  });

  // Arrow functions work too — note: no own `this`
  btn.addEventListener("click", (e) => {
    e.target.textContent = "Clicked!";
  });
  ```

  The `event` object carries information about what happened:

  | Property / Method    | What it gives you                              |
  |----------------------|------------------------------------------------|
  | `event.target`       | The element that fired the event               |
  | `event.currentTarget`| The element the listener is attached to        |
  | `event.type`         | `"click"`, `"submit"`, `"keydown"`, …         |
  | `event.preventDefault()` | Stop the browser's default action (e.g. form submit, link follow) |
  | `event.stopPropagation()` | Don't let the event bubble up further    |

  ### Preventing Default Behaviour

  ```javascript
  const form = document.querySelector("form");

  form.addEventListener("submit", (e) => {
    e.preventDefault();   // stop the page from reloading
    const data = new FormData(form);
    console.log(Object.fromEntries(data));
    // now send to the server yourself with fetch()
  });
  ```

  ### Event Delegation

  Attaching one listener to a *parent* element instead of hundreds of
  listeners to individual children is dramatically more efficient and
  works automatically for dynamically added elements:

  ```javascript
  // Instead of this (one listener per button):
  document.querySelectorAll(".item-delete").forEach(btn => {
    btn.addEventListener("click", handleDelete);
  });

  // Do this (one listener on the parent):
  document.querySelector("#item-list").addEventListener("click", (e) => {
    if (e.target.matches(".item-delete")) {
      handleDelete(e);
    }
  });
  ```

  This pattern is why `e.target` (what was actually clicked) and
  `e.currentTarget` (where the listener lives) can differ.

  ### Removing Listeners

  Always remove listeners you no longer need to avoid memory leaks:

  ```javascript
  function handleClick(e) { /* … */ }

  btn.addEventListener("click", handleClick);
  // later…
  btn.removeEventListener("click", handleClick);
  // Note: must be the same function reference — anonymous functions can't be removed!
  ```
MD

js_async = <<~'MD'
  ## Asynchronous JavaScript — Promises and async/await

  JavaScript is **single-threaded** — it can only do one thing at a time.
  Yet the browser must stay responsive while waiting for a network response
  or a timer. Asynchronous programming is how JavaScript resolves this
  contradiction, and understanding it separates intermediate developers
  from advanced ones.

  ### The Event Loop

  The engine runs an infinite loop. On each *tick* it processes one item
  from the **call stack**, and when the stack is empty it picks up the next
  item from the **callback queue**:

  ```mermaid
  flowchart LR
    CS["Call Stack\n(runs synchronously)"] -- "stack empty" --> EL["Event Loop"]
    EL --> CQ["Callback Queue\n(setTimeout, events, …)"]
    CQ -- "dequeue one" --> CS
    WEB["Web APIs\n(fetch, setTimeout, DOM)"] -- "on completion" --> CQ
    CS -- "calls" --> WEB
  ```

  ```javascript
  console.log("1 — start");

  setTimeout(() => console.log("3 — timeout"), 0);

  console.log("2 — end");

  // Output: 1 — start, 2 — end, 3 — timeout
  // Even with a 0ms delay, the callback only runs after the stack clears
  ```

  ### Callbacks — The Original Pattern

  Before Promises, asynchronous operations used callbacks:

  ```javascript
  fetch("/api/users", function(error, users) {
    if (error) { /* handle */ return; }
    fetchOrders(users[0].id, function(error, orders) {
      if (error) { /* handle */ return; }
      fetchItems(orders[0].id, function(error, items) {
        // "Callback Hell" — also known as the Pyramid of Doom
      });
    });
  });
  ```

  Deeply nested callbacks are notoriously hard to read, test, and maintain.

  ### Promises

  A **Promise** is an object representing a value that will be available
  in the future. It is always in one of three states:

  ```mermaid
  flowchart LR
    P["Pending"] --> F["Fulfilled (value)"]
    P --> R["Rejected (error)"]
  ```

  ```javascript
  fetch("https://api.example.com/users")  // returns a Promise
    .then(response => response.json())    // .then chains on success
    .then(users => console.log(users))
    .catch(error => console.error(error)) // .catch handles any error
    .finally(() => hideSpinner());        // always runs
  ```

  `.then()` returns a **new** Promise, which is why chaining works. Each
  `.then()` receives the resolved value of the previous one.

  ### Creating Your Own Promises

  ```javascript
  function delay(ms) {
    return new Promise((resolve) => {
      setTimeout(resolve, ms);
    });
  }

  delay(1000).then(() => console.log("one second later"));
  ```

  ### async / await — Synchronous-Looking Async Code

  `async`/`await` is syntactic sugar over Promises. It lets you write
  asynchronous code that *reads* like synchronous code:

  ```javascript
  async function loadUserDashboard(userId) {
    try {
      const response = await fetch(`/api/users/${userId}`);

      if (!response.ok) {
        throw new Error(`HTTP error: ${response.status}`);
      }

      const user   = await response.json();
      const orders = await fetch(`/api/orders?user=${userId}`)
                           .then(r => r.json());

      return { user, orders };

    } catch (error) {
      console.error("Failed to load dashboard:", error);
      throw error; // re-throw so the caller can handle it too
    }
  }
  ```

  Every `async` function **always returns a Promise**, even if you return a
  plain value. `await` pauses execution of the `async` function only — the
  rest of the program keeps running.

  ### Running Operations in Parallel

  `await` in sequence is useful but slow when operations are independent:

  ```javascript
  // Sequential — total time = time(A) + time(B) + time(C)
  const a = await fetchA();
  const b = await fetchB();
  const c = await fetchC();

  // Parallel — total time = max(time(A), time(B), time(C))
  const [a, b, c] = await Promise.all([ fetchA(), fetchB(), fetchC() ]);
  ```

  Use `Promise.all()` whenever your operations do not depend on each other.
  Use `Promise.allSettled()` when you want results even if some fail.

  ### The Golden Rules of Async JavaScript

  1. **Always handle errors.** Unhandled Promise rejections crash Node.js
     processes and are silent bugs in the browser.
  2. **Await in async, not in the top level** (unless your environment
     supports top-level await).
  3. **Don't `await` inside `forEach`** — it doesn't wait. Use `for...of`
     or `Promise.all(array.map(...))` instead.

  ```javascript
  // Wrong — forEach ignores returned Promises
  items.forEach(async (item) => { await process(item); });

  // Right — for...of respects await
  for (const item of items) { await process(item); }

  // Right — parallel processing
  await Promise.all(items.map(item => process(item)));
  ```
MD

# ---------------------------------------------------------------------------
# JavaScript Fundamentals course definition
# ---------------------------------------------------------------------------
courses = [
  {
    slug: "intro-to-ruby",
    title: "Intro to Ruby",
    summary: "Learn the fundamentals of the Ruby programming language.",
    description: "Get comfortable with Ruby's syntax, objects, and collections through short, hands-on lessons.",
    badge: { name: "Ruby Initiate", icon: "💎", description: "Completed the Intro to Ruby course." },
    lessons: [
      {
        slug: "variables-and-types", title: "Variables and Types", minutes: 8, body: ruby_variables,
        questions: [
          [ "Which symbol assigns a value in Ruby?", [ [ "=", true ], [ "==", false ], [ "=>", false ] ] ],
          [ "Everything in Ruby is a(n)…", [ [ "object", true ], [ "pointer", false ], [ "primitive", false ] ] ],
          [ "How do you interpolate in a double-quoted string?", [ [ '#{}', true ], [ "${}", false ], [ "%{}", false ] ] ]
        ]
      },
      {
        slug: "methods-and-blocks", title: "Methods and Blocks", minutes: 10, body: ruby_methods,
        questions: [
          [ "Which keyword defines a method?", [ [ "def", true ], [ "func", false ], [ "method", false ] ] ],
          [ "What runs the block passed to a method?", [ [ "yield", true ], [ "return", false ], [ "call_block", false ] ] ],
          [ "Blocks are passed using…", [ [ "{ } or do/end", true ], [ "[ ]", false ], [ "< >", false ] ] ]
        ]
      },
      {
        slug: "collections", title: "Collections", minutes: 9, body: ruby_collections,
        questions: [
          [ "Which stores ordered values?", [ [ "Array", true ], [ "Hash", false ], [ "Symbol", false ] ] ],
          [ "What does scores[:grace] do?", [ [ "reads a Hash by key", true ], [ "reads an Array by index", false ], [ "defines a method", false ] ] ],
          [ "Which transforms each element?", [ [ "map", true ], [ "push", false ], [ "length", false ] ] ]
        ]
      }
    ]
  },
  {
    slug: "git-basics",
    title: "Git Basics",
    summary: "Track your work and collaborate with Git version control.",
    description: "Understand commits, branches, and remotes — the core workflow every developer uses daily.",
    badge: { name: "Version Control Voyager", icon: "🧭", description: "Completed the Git Basics course." },
    lessons: [
      {
        slug: "what-is-git", title: "What is Git?", minutes: 6, body: git_what,
        questions: [
          [ "Git is a … version control system.", [ [ "distributed", true ], [ "centralized", false ], [ "manual", false ] ] ],
          [ "Which command shows the current state?", [ [ "git status", true ], [ "git list", false ], [ "git show-all", false ] ] ],
          [ "What moves files to staging?", [ [ "git add", true ], [ "git commit", false ], [ "git push", false ] ] ]
        ]
      },
      {
        slug: "commits-and-branches", title: "Commits and Branches", minutes: 12, body: git_commits,
        questions: [
          [ "A commit is best described as a…", [ [ "snapshot", true ], [ "backup server", false ], [ "remote", false ] ] ],
          [ "Which creates and switches to a branch?", [ [ "git checkout -b", true ], [ "git branch --delete", false ], [ "git merge", false ] ] ],
          [ "A branch is a movable pointer to a…", [ [ "commit", true ], [ "file", false ], [ "remote", false ] ] ]
        ]
      },
      {
        slug: "remotes-and-pushing", title: "Remotes and Pushing", minutes: 8, body: git_remotes,
        questions: [
          [ "A remote is a … copy of your repo.", [ [ "shared", true ], [ "temporary", false ], [ "compressed", false ] ] ],
          [ "The default remote is conventionally named…", [ [ "origin", true ], [ "main", false ], [ "server", false ] ] ],
          [ "Which uploads local commits?", [ [ "git push", true ], [ "git pull", false ], [ "git fetch", false ] ] ]
        ]
      }
    ]
  },
  {
    slug: "javascript-fundamentals",
    title: "JavaScript Fundamentals",
    summary: "Master the language of the web — from variables and closures to the event loop and async/await.",
    description: <<~DESC,
      JavaScript is the only programming language that runs natively in every web browser, and
      increasingly on servers and native apps via Node.js and Electron. This course builds a
      rigorous understanding of the language's core mechanics: how scope and closures work, why
      `this` behaves the way it does, how the event loop makes single-threaded async I/O possible,
      and how modern ES6+ syntax makes all of it more readable. Each lesson ends with a quiz that
      tests understanding, not just recall.
    DESC
    badge: { name: "JavaScript Journeyman", icon: "🟨", description: "Completed the JavaScript Fundamentals course." },
    lessons: [
      {
        slug: "variables-types-and-scope",
        title: "Variables, Types, and Scope",
        minutes: 12,
        body: js_variables,
        questions: [
          [ "Which declaration is block-scoped and cannot be reassigned?", [ [ "const", true ], [ "let", false ], [ "var", false ] ] ],
          [ "What is `typeof null` in JavaScript?", [ [ '"object"', true ], [ '"null"', false ], [ '"undefined"', false ] ] ],
          [ "Which equality operator checks both value AND type?", [ [ "===", true ], [ "==", false ], [ "=", false ] ] ],
          [ "What is the key problem with `var`?", [ [ "It is function-scoped and hoisted, not block-scoped", true ], [ "It cannot hold string values", false ], [ "It requires a type annotation", false ] ] ]
        ]
      },
      {
        slug: "functions-first-class-citizens",
        title: "Functions — First-Class Citizens",
        minutes: 15,
        body: js_functions,
        questions: [
          [ "A closure is a function that…", [ [ "remembers variables from its enclosing scope", true ], [ "cannot take arguments", false ], [ "always returns undefined", false ] ] ],
          [ "Which function type does NOT have its own `this`?", [ [ "Arrow function", true ], [ "Function declaration", false ], [ "Function expression", false ] ] ],
          [ "A higher-order function is one that…", [ [ "takes or returns a function", true ], [ "runs faster than regular functions", false ], [ "is declared with `class`", false ] ] ],
          [ "What does the rest parameter (`...args`) do?", [ [ "Gathers remaining arguments into an array", true ], [ "Spreads an array into individual arguments", false ], [ "Prevents a function from returning a value", false ] ] ]
        ]
      },
      {
        slug: "objects-classes-and-this",
        title: "Objects, Classes, and `this`",
        minutes: 14,
        body: js_objects,
        questions: [
          [ "ES6 classes are syntactic sugar over…", [ [ "prototype-based inheritance", true ], [ "classical OOP with a vtable", false ], [ "closures only", false ] ] ],
          [ "What determines the value of `this` in a regular function?", [ [ "How the function is called (call site)", true ], [ "Where the function is defined", false ], [ "The file it appears in", false ] ] ],
          [ "The spread operator `{...obj}` creates…", [ [ "a shallow copy of the object", true ], [ "a deep clone of all nested objects", false ], [ "a reference to the same object", false ] ] ],
          [ "When does the prototype chain activate?", [ [ "When a property isn't found directly on the object", true ], [ "Only inside class constructors", false ], [ "Whenever you use the `new` keyword", false ] ] ]
        ]
      },
      {
        slug: "arrays-and-the-functional-toolkit",
        title: "Arrays and the Functional Toolkit",
        minutes: 12,
        body: js_arrays,
        questions: [
          [ "Which method transforms every element and returns a new array of the same length?", [ [ "map", true ], [ "filter", false ], [ "reduce", false ] ] ],
          [ "What does `filter` return when no elements pass the test?", [ [ "An empty array", true ], [ "null", false ], [ "undefined", false ] ] ],
          [ "Why is passing a comparator to `sort` important for numbers?", [ [ "Default sort coerces to strings, giving wrong numeric order", true ], [ "Numbers cannot be sorted without a comparator", false ], [ "Comparators make sort run faster", false ] ] ],
          [ "What is the correct way to process async operations for each array item?", [ [ "for...of with await, or Promise.all with map", true ], [ "forEach with async callback", false ], [ "reduce with await", false ] ] ]
        ]
      },
      {
        slug: "the-dom-and-events",
        title: "The DOM and Event-Driven Programming",
        minutes: 12,
        body: js_dom,
        questions: [
          [ "What does `querySelector` return when no element matches?", [ [ "null", true ], [ "undefined", false ], [ "An empty NodeList", false ] ] ],
          [ "What does `event.preventDefault()` do?", [ [ "Stops the browser's built-in action for that event", true ], [ "Removes the event listener", false ], [ "Stops the event from firing entirely", false ] ] ],
          [ "Why is event delegation more efficient than per-element listeners?", [ [ "One listener on a parent handles all children, including future ones", true ], [ "The browser processes delegated events faster internally", false ], [ "It avoids the event loop entirely", false ] ] ],
          [ "Why can't you remove an anonymous function with removeEventListener?", [ [ "removeEventListener requires the same function reference", true ], [ "Anonymous functions are not valid event handlers", false ], [ "removeEventListener only works on the window object", false ] ] ]
        ]
      },
      {
        slug: "async-javascript-promises-and-await",
        title: "Async JavaScript — Promises and async/await",
        minutes: 16,
        body: js_async,
        questions: [
          [ "What are the three possible states of a Promise?", [ [ "Pending, Fulfilled, Rejected", true ], [ "Loading, Done, Error", false ], [ "Open, Closed, Cancelled", false ] ] ],
          [ "An `async` function always returns…", [ [ "a Promise", true ], [ "the raw value you return", false ], [ "undefined unless you use await", false ] ] ],
          [ "Which method runs multiple Promises in parallel and waits for all?", [ [ "Promise.all()", true ], [ "Promise.race()", false ], [ "Promise.resolve()", false ] ] ],
          [ "Why does `await` inside `forEach` not work as expected?", [ [ "forEach ignores the Promise returned by the async callback", true ], [ "await is not valid inside any callback", false ], [ "forEach runs callbacks synchronously regardless", false ] ] ]
        ]
      }
    ]
  }
]

courses.each_with_index do |data, ci|
  course = Course.find_or_initialize_by(slug: data[:slug])
  course.assign_attributes(
    title: data[:title], summary: data[:summary],
    description: data[:description], position: ci + 1, published: true
  )
  course.save!

  badge = Badge.find_or_initialize_by(course: course)
  badge.assign_attributes(data[:badge])
  badge.save!

  data[:lessons].each_with_index do |ld, li|
    lesson = course.lessons.find_or_initialize_by(slug: ld[:slug])
    lesson.assign_attributes(
      title: ld[:title], body: ld[:body],
      position: li + 1, estimated_minutes: ld[:minutes], published: true
    )
    lesson.save!

    quiz = lesson.quiz || lesson.build_quiz
    quiz.assign_attributes(title: "#{lesson.title} quiz", pass_percentage: 70)
    quiz.save!

    next if quiz.questions.exists?

    ld[:questions].each_with_index do |(prompt, options), qi|
      question = quiz.questions.create!(prompt: prompt, position: qi + 1)
      options.each_with_index do |(body, correct), oi|
        question.answer_options.create!(body: body, correct: correct, position: oi + 1)
      end
    end
  end
end

puts "Seeded #{User.count} users, #{Course.count} courses, #{Lesson.count} lessons, " \
     "#{Quiz.count} quizzes, #{Question.count} questions, #{Badge.count} badges."
