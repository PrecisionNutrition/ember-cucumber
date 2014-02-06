Then(/^I should be in an Ember app$/) do
  wait_for_ember_run_loop_to_complete
end

AfterStep('@ember-app') do
  wait_for_ember_run_loop_to_complete
end
