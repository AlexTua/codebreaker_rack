feature Racker do
  background do
    visit '/'

  end

  scenario 'Decreases attempts' do
    fill_in('guess', with: '1111')
    click_button('Try')
    expect(page).to have_content('Attempts left: 6')
  end

  scenario 'Show player guess' do
    fill_in('guess', with: '2211')
    click_button('Try')
    expect(page).to have_content('Your guess: 2211')
  end

  scenario 'Show lose message' do
    7.times do
      fill_in('guess', with: '1111')
      click_button('Try')
    end
    expect(page).to have_content('You lose')
  end

  scenario 'Have turns table' do
    expect(page).to have_table('TURNS')
  end

  scenario 'Restart game' do
    fill_in('guess', with: '1111')
    click_button('Try')
    click_link('Restart')
    expect(page).to have_content('Attempts left: 7')
  end

  scenario 'Give a hint' do
    click_link('Hint')
    expect(page).to have_content('One number of secret code is')
  end

  scenario 'Have records table' do
    click_link('Records')
    expect(page).to have_table('RECORDS')
  end
end