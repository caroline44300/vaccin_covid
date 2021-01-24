# Preview all emails at http://localhost:3000/rails/mailers/availabilities_mailer
class AvailabilitiesMailerPreview < ActionMailer::Preview
  def there_is_availabilities_email
    @sites = [{name: "doctolib", dispo: "Il y a des disponibilités ! GO GO GO 🚀", url: "https://www.doctolib.fr/vaccination-covid-19/loire-atlantique" }]

    AvailabilitiesMailer.with(sites_availabilities: @sites).there_is_availabilities_email
  end

  def there_might_be_availabilities_email
    @receiver = "caroline.douet1@gmail.com"
    @sites = [{name: "maiia", dispo: "Il y a peut-être des disponibilités ! Vas voir 💉", url: "https://www.maiia.com/centre-de-vaccination/44000-NANTES" },
      {name: "keldoc", dispo: "Il y a peut-être des disponibilités ! Vas voir 💉", url: "https://www.keldoc.com/vaccination-covid-19/loire-atlantique" }
    ]
    AvailabilitiesMailer.with(sites_maybe: @sites).there_might_be_availabilities_email
  end
end
