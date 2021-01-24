class PagesController < ApplicationController

  def home
    @dispo_docto, @dispo_maiia, @dispo_keldoc = dispos_sites
  end

  private

  def dispos_sites
    # open a browser
    browser = Watir::Browser.new :chrome, headless: true

    docto_dispo = check_docto(browser)

    maiia_dispo = check_maiia(browser)

    keldoc_dispo = check_keldoc(browser)

    browser.close

    # check type of dispo and group
    maybe_availabilities = []
    availabilities = []
    sites = [
      { name: "doctolib", dispo: docto_dispo, url: "https://www.doctolib.fr/vaccination-covid-19/loire-atlantique" },
      { name: "maiia", dispo: maiia_dispo, url: "https://www.maiia.com/centre-de-vaccination/44000-NANTES" },
      { name: "keldoc", dispo: keldoc_dispo, url: "https://www.keldoc.com/vaccination-covid-19/loire-atlantique" }
    ]

    sites.each do |site|
      if site[:dispo] == "Il y a des disponibilités ! GO GO GO 🚀"
        availabilities << site
      elsif site[:dispo] == "Il y a peut-être des disponibilités ! Vas voir 💉"
        maybe_availabilities << site
      end
    end

    # send emails if necessary

    if !availabilities.empty?
      AvailabilitiesMailer.with(sites_availabilities: availabilities).there_is_availabilities_email.deliver_now
    elsif !maybe_availabilities.empty?
      AvailabilitiesMailer.with(sites_maybe: maybe_availabilities).there_might_be_availabilities_email.deliver_now
    end

    return docto_dispo, maiia_dispo, keldoc_dispo
  end

  def check_docto(browser)
    # go to doctolib site
    browser.goto("https://www.doctolib.fr/vaccination-covid-19/loire-atlantique")

    # accept cookies
    cookie_button = browser.element(id: 'didomi-notice-agree-button')
    cookie_button.click

    # scroll to bottom
    10.times do
      browser.scroll.by(0, 300)
      sleep(0.1)
    end

    # check if there are 8 no_availabilities alerts
    no_availabilities_alerts = browser.spans(text: '')

    if no_availabilities_alerts.size == 8
      dispo_docto = "Il n'y a pas de disponibilité ❌"
    elsif browser.element(class: 'availabilities-slot').exists?
        dispo_docto = "Il y a des disponibilités ! GO GO GO 🚀"
    elsif browser.element(class: 'availabilities-next-slot').exists?
        dispo_docto = "Il y a peut-être des disponibilités ! Vas voir 💉"
    end
    dispo_docto
  end

  def check_maiia(browser)
    browser.goto("https://www.maiia.com/centre-de-vaccination/44000-NANTES")

    cookie_button = browser.element(text: 'Accepter tous les cookies')
    cookie_button.click


    #check if alert exists
    alert = browser.element(class: 'info-availability').exists?

    if alert
      maiia_dispo = "Il n'y a pas de disponibilité ❌"
    else
      maiia_dispo = "Il y a des disponibilités ! GO GO GO 🚀"
    end
    maiia_dispo
  end

  def check_keldoc(browser)
    # repeat for kedoc site

    browser.goto("https://www.keldoc.com/vaccination-covid-19/loire-atlantique")

    cookie_button = browser.button(class: 'nehs-cookie-button')

    cookie_button.click

    #check if alert exists
    alert = browser.div(class: 'alert').exists?

    if alert
      keldoc_dispo = "Il n'y a pas de disponibilité ❌"
    else
      keldoc_dispo = "Il y a des disponibilités ! GO GO GO 🚀"
    end
  end
end
