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
# Course definitions
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
