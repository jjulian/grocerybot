class Robot
  @separators = %w{,.:;|}

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
    when ADD
      'OK, added.'
      # TODO parse and update db
    when REMOVE
      'OK, removed.'
      # TODO parse and update db
    when REMOVE_ALL
      'Your list is empty.'
      # TODO parse and update db
    when LIST
      'Here\'s what you need so far:'
      # TODO enumerate
    else
      'Hmm. I didn\'t quite get that. Use "add" or "remove" or "list".'
    end
  end

  def operation_for(text)
    if text =~ /\bneed\b|\badd\b/i
      Operation::ADD
    elsif text =~ /\bremove\b/i
      Operation::REMOVE
    elsif text =~ /\bclear list\b/i
      Operation::REMOVE_ALL
    elsif text =~ /\blist\b|\bshow\b/i
      Operation::LIST
    else
      Operation::UNKNOWN
    end
  end
end
