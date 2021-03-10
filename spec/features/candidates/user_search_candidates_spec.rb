require 'rails_helper'

feature 'user search candidates' do
  before { candidate }

  let(:candidate) do
    Candidate.create(city: 'rio de janeiro - rj',  experience: '5-6',
      technologies: [{ name: 'sass', is_main_tech: true }])
  end

  scenario 'successfully find candidates' do
    visit root_path

    fill_in 'Candidatos de', with: 'Rio de Janeiro'
    fill_in 'para trabalhar com', with: 'Sass'
    fill_in 'que possuem', with: '1 ano ou mais de experiência'
    click_on 'Buscar'

    expect(page)
      .to have_content('Foram encontradas 1 vagas para Desenvolvedor Sass :)')
    expect(page).to have_content("Pessoa Desenvolvedora ##{candidate.id}")
    expect(page).to have_content("Localização: #{candidate.city}")
    expect(page).to have_content("Experiência: #{candidate.experience}")
    expect(page).to have_content('Tecnologias: | sass |')
    expect(page).not_to have_link('Buscar')
    expect(current_path).to eq candidates_path
  end

  scenario 'dont find any candidates' do
      visit root_path

      fill_in 'Candidatos de', with: ''
      fill_in 'para trabalhar com', with: ''
      fill_in 'que possuem', with: ''
      click_on 'Buscar' 

      expect(page).not_to have_content('Pessoa Desenvolvedora')
      expect(page).not_to have_content('Localização')
      expect(page).not_to have_content('Experiência')
      expect(page).not_to have_content('Tecnologias')
      expect(page).not_to have_link('Buscar')
      expect(current_path).to eq candidates_path
  end
end
