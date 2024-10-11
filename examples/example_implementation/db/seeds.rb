# frozen_string_literal: true

Book.create!(
  name: "The Great Gatsby",
  description: "A novel written by F. Scott Fitzgerald."
)

Book.create!(
  name: "1984",
  description: "A dystopian social science fiction novel by George Orwell."
)

Book.create!(
  name: "To Kill a Mockingbird",
  description: "A novel by Harper Lee published in 1960."
)

puts "#{Book.count} Books in archive!"
