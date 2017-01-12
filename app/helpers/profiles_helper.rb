module ProfilesHelper
  def of_username(profile)
    if locale == :el
      of = (profile.female?) ? 'της' : 'του'
    else
      of = 'of'
    end
    "#{of} #{profile.username}"
  end
end
