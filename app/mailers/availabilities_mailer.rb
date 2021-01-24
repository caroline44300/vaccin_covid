class AvailabilitiesMailer < ApplicationMailer

  def there_is_availabilities_email
    @receiver = "caroline.douet1@gmail.com"
    @sites = params[:sites_availabilities]

    mail(to: @receiver, subject: "💚 Vaccination Covid19 - Il y a de la disponibilité ! 💚")
  end

  def there_might_be_availabilities_email
    @receiver = "caroline.douet1@gmail.com"
    @sites = params[:sites_maybe]

    mail(to: @receiver, subject: "🧡 Vaccination Covid19 - Il y a peut-être de la disponibilité ! 🧡")
  end
end
