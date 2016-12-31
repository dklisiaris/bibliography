module ActivitiesHelper
  # Returns the proper verb based on activity key (i.e. recommends, wants to read etc.)
  def activity_verb(activity)
    case activity.key
    when "book.recommend"
      t('users.verbs.recommended')
    when "book.not_recommend"
      t('users.verbs.not_recommends')
    when "book.my_library"
      t('users.verbs.owns_in_library')
    when "book.want_to_read"
      t('users.verbs.wants_to_read')
    when "book.favourites"
      t('users.verbs.add_to_favourites')
    when "book.currently_reading"
      t('users.verbs.currently_reads')
    when "book.read_but_not_own"
      t('users.verbs.read_but_not_own')
    when "book.to_read"
      t('users.verbs.will_read')
    end
  end

  def activity_article(activity)
    if locale == :el
      (activity.owner.profile.female?) ? 'Η' : 'Ο'
    end
  end
end
