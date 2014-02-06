require "ember/cucumber/version"

module Ember
  module Cucumber
    def wait_for_html_element_on_page
      2000.times do
        if page
          find :css, "html"
        end
        sleep 0.01
      end
    end

    def wait_for_page_to_load
      2000.times do
        unless page
          sleep 0.01
        end
      end
      expect(page).to be
    end

  # Chill out until Ember is ready to go. First we wait for the page to load, because redirects
  # (e.g. Doorkeeper) can confuse things. Once the page is loaded, we check that it's
  # an Ember app (.ember-application), and that .application-ready class (from Shared.LoadingRouteMixin) is
  # present.
  def wait_for_ember_application_to_load
    # These first two blocks are from the BrowserHelpers module. We need to ensure that the page is
    # loaded before we start running finds on CSS
    patiently do
      wait_for_page_to_load
    end
    patiently do
      wait_for_html_element_on_page
    end

    # Now, patiently wait for the .ember-application class to make sure we're in an ember app,
    # and .application-ready to verify that it's ready to respond to requests.
    using_wait_time 20 do
      patiently do
        find ".ember-application"
      end
      patiently do
        find ".application-ready"
      end
    end

    # So now the application is ready but there might be something in the run loop. Chill
    # and wait for that to finish.
    wait_for_ember_run_loop_to_complete
  end

  # This runs after every step in a tagged scenario, or whenver
  # we need to specifically make sure that Ember is done with whatever
  # it is working on.
  def wait_for_ember_run_loop_to_complete
    # These first two blocks are from the BrowserHelpers module. We need to ensure that the page is
    # loaded before we start running finds on CSS
    patiently do
      wait_for_page_to_load
    end
    patiently do
      wait_for_html_element_on_page
    end

    # At this point the page should be loaded, so if we don't see .ember-application,
    # we assume it's not an Ember app and this method can just return because there's nothing
    # to wait for. Since this is used in tagged scenarios, there might be pages in the scenario
    # that aren't Ember-fied (e.g. Doorkeeper's pages). We don't want to fail; we just want to fall
    # through.
    patiently do
      return unless page.has_css? '.ember-application'
    end

    # And here is where the magic happens. We check that Ember is instantiated, that there are no
    # scheduled timers, and that there is no current run loop. This is the way that Ember does it
    # internally, so hey, if it's good enough for production, it's good enough for testing.
    2000.times do #this means up to 20 seconds
      return if page.evaluate_script "'undefined' == typeof window.jQuery"
      return if page.evaluate_script "jQuery.active === 0 && jQuery('body').hasClass('application-ready') && (typeof Ember === 'object') && !Ember.run.hasScheduledTimers() && !Ember.run.currentRunLoop"
      sleep 0.01
    end
  end

  # We display a spinner while Ember is loading everything it needs to. Once that goes away, it
  # means Ember is done loading and we can proceed. Humans are smart enough to know that this is
  # happening; cucumber is somewhat less than human.
  def wait_for_ember_loading_to_complete
    # Ensure that the page is loaded before we start looking for the loading_overlay class.
    patiently do
      wait_for_page_to_load
    end
    patiently do
      wait_for_html_element_on_page
    end

    # Once the page is loaded, we're going to check to see if the .loading_overlay class
    # is there. If it's not, we're going to assume that Ember is done loading. If it is
    # still there, we take a quick catnap and check again for up to 20 seconds.
    using_wait_time 20 do
      patiently do
        return unless page.has_css? '.loading_overlay'
        sleep 0.01
      end
    end
  end
end
