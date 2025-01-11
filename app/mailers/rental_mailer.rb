class RentalMailer < ApplicationMailer
  layout 'mailer'

  def payment_refused(rental:)
    @rental = rental
    @account_url = account_url
    mail(to: rental.subscription.user.email, subject: "Payment Refused - Subscription paused and action required")
  end

  def sent(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox Sent - #{rental.puzzle.name} on its way!")
  end

  def delivered(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox Delivered!")
  end

  def to_be_returned(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox to be returned - #{rental.puzzle.name}")
  end

  def late(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox late return - #{rental.puzzle.name}")
  end

  def returned(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox returned - Thank you!")
  end

  def lost(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    @account_url = account_url
    mail(to: rental.subscription.user.email, subject: "Cluebox lost - Action required")
  end

  def return_approved(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    mail(to: rental.subscription.user.email, subject: "Cluebox return approved - Thank you!")
  end

  def return_denied(rental:)
    @rental = rental
    @puzzle = rental.puzzle
    @account_url = account_url
    mail(to: rental.subscription.user.email, subject: "Cluebox return rejected - Action required")
  end
end
