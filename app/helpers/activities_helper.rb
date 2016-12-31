module ActivitiesHelper
  # Returns the proper verb based on activity key (i.e. recommends, wants to read etc.)
  def activity_verb(activity)
    case activity.key
    when "book.recommend"
      t('users.verbs.recommended')
    when "book.not_recommend"
      t('users.verbs.not_recommends')
    end
  end

  def activity_article(activity)
    if locale == :el
      (activity.owner.profile.female?) ? 'Η' : 'Ο'
    end
  end
end
