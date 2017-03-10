class Robot

  module Operation
    ADD = 'add'
    REMOVE = 'remove'
    REMOVE_ALL = 'remove_all'
    LIST = 'list'
    UNKNOWN = 'unknown'
  end

  def initialize(attributes)
    @creator = attributes[:creator]
  end

  def reply_to(text)
    operation = operation_for(text)
    case operation

    when Operation::ADD
      item_names = parse_items_from(text)
      if !item_names.empty?
        item_names.each { |name| Item.create!(name: name, creator: @creator) }
        "OK, I added #{item_names.join(', ')}."
      else
        "You didn't tell me anything to add!"
      end

    when Operation::REMOVE
      item_names = parse_items_from(text)
      if !item_names.empty?
        item_names.each do |name|
          Item.where(name: name, removed_at: nil).each do |item|
            item.touch(:removed_at)
          end
        end
        "OK, I removed #{item_names.join(', ')}."
      else
        "You didn't tell me anything to remove!"
      end

    when Operation::REMOVE_ALL
      Item.still_needed.each do |item|
        item.touch(:removed_at)
      end
      'Your list is now empty.'

    when Operation::LIST
      item_names = Item.still_needed.map { |item| item.name }.join("\n")
      "Here\'s your grocery list:\n#{item_names}"
    else
      'Hmm. I didn\'t quite get that. I can "add <item>" or "remove <item>" or "list".'
    end
  end

  KEYWORDS = ['need','add','remove']
  SEPARATORS_REGEX = /\,|\.|\:|\;|\|/

  def parse_items_from(text)
    words = text.split(' ')
    # drop all words up to and including a keyword
    items_str = words.reverse.take_while { |w| !KEYWORDS.include?(w.downcase) }.reverse.join(' ')
    # split the remaining words on punctuation
    items_str.split(SEPARATORS_REGEX).map { |item| item.strip }
  end

  def operation_for(text)
    if text =~ /\bneed\b|\badd\b/i
      Operation::ADD
    elsif text =~ /\bremove\b/i
      Operation::REMOVE
    elsif text =~ /\blist\b|\bshow\b/i
      Operation::LIST
    elsif text =~ /\bclear list\b/i
      Operation::REMOVE_ALL
    else
      Operation::UNKNOWN
    end
  end
end
