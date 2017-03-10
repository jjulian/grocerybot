class Robot

  module Operation
    ADD = 'add'
    REMOVE = 'remove'
    REMOVE_ALL = 'remove_all'
    LIST = 'list'
    UNKNOWN = 'unknown'
  end

  def reply_to(text)
    operation = operation_for(text)
    case operation
    when Operation::ADD
      items = parse_items_from(text)
      if !items.empty?
        # TODO update db
        "OK, I added #{items.join(', ')}."
      else
        "You didn't tell me anything to add!"
      end
    when Operation::REMOVE
      items = parse_items_from(text)
      if !items.empty?
        # TODO update db
        "OK, I removed #{items.join(', ')}."
      else
        "You didn't tell me anything to remove!"
      end
    when Operation::REMOVE_ALL
      # TODO update db
      'Your list is now empty.'
    when Operation::LIST
      'Here\'s what you need so far:'
      # TODO enumerate
    else
      'Hmm. I didn\'t quite get that. I can "add <item>" or "remove <item>" or "list".'
    end
  end

  KEYWORDS = ['need','add','remove']
  SEPARATORS_REGEX = /\,|\.|\:|\;|\|/

  def parse_items_from(text)
    words = text.split(' ')
    # drop all words up to and including a keyword
    items_str = words.reverse.take_while { |w| !KEYWORDS.include?(w) }.reverse.join(' ')
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
