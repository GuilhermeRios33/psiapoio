import '../models/clinic.dart';

const List<Clinic> clinics = [
  Clinic(
    name: 'Psicologia Hoje em Dia',
    address: 'Av. José Falcão da Silva, 1162 - Queimadinha, Feira de Santana - BA, 44050-512',
    placeId: 'ChIJJes_-h05FAcR9iWn6JSLxk4',
    lat: -12.246473,
    lng: -38.966378,
    phone: '',
    about:
        'Clínica especializada em saúde mental, oferecendo atendimento individualizado com foco no bem-estar emocional. Nossa equipe está comprometida com a qualidade e eficácia no processo terapêutico.',
    rating: 4.8,
    reviewCount: 23,
    specialties: ['Ansiedade', 'Depressão', 'Autoestima'],
    topics: ['Ansiedade', 'Depressão', 'Autoestima'],
    reviews: [
      Review(
        reviewerName: 'Mariana S.',
        rating: 5,
        comment: 'Profissional incrível, me ajudou muito a lidar com a ansiedade.',
      ),
      Review(
        reviewerName: 'João P.',
        rating: 5,
        comment: 'Ambiente acolhedor e atendimento de excelência. Recomendo!',
      ),
    ],
  ),
  Clinic(
    name: 'Camilla Ribeiro - Diário do Psique',
    address: 'R. Castro Alves, 260 - Serraria Brasil, Feira de Santana - BA, 44003-201',
    placeId: 'ChIJSUqVC743FAcRBMcWv0E980c',
    lat: -12.261895,
    lng: -38.956795,
    phone: '',
    about:
        'Espaço terapêutico dedicado ao autoconhecimento e transformação pessoal. Atendimento humanizado com abordagem psicanalítica e cognitivo-comportamental.',
    rating: 4.9,
    reviewCount: 41,
    specialties: ['Psicanálise', 'Terapia Cognitivo-Comportamental', 'Relacionamentos'],
    topics: ['Autoconhecimento', 'Casal', 'Depressão'],
    reviews: [
      Review(
        reviewerName: 'Fernanda C.',
        rating: 5,
        comment: 'Camilla é extremamente atenciosa. O processo terapêutico mudou minha vida.',
      ),
      Review(
        reviewerName: 'Pedro R.',
        rating: 5,
        comment: 'Muito competente e empática. Sessões muito produtivas.',
      ),
    ],
  ),
  Clinic(
    name: 'Contigo - Instituto de Psicologia Clínica e Organizacional',
    address: 'Av. Getúlio Vargas, 455 - Centro, Feira de Santana - BA, 44001-525',
    placeId: 'ChIJh1cvAm83FAcRF4QAnx404Aw',
    lat: -12.257529,
    lng: -38.961917,
    phone: '',
    about:
        'Instituto com abordagem multidisciplinar em psicologia clínica e organizacional. Atendemos adultos, adolescentes e empresas em busca de desenvolvimento e equilíbrio.',
    rating: 4.7,
    reviewCount: 55,
    specialties: ['Psicologia Organizacional', 'Desenvolvimento Pessoal', 'Liderança'],
    topics: ['Ansiedade', 'Autoestima', 'Burnout'],
    reviews: [
      Review(
        reviewerName: 'Beatriz M.',
        rating: 5,
        comment: 'Equipe multidisciplinar excelente. Meu desenvolvimento foi notável.',
      ),
      Review(
        reviewerName: 'Rafael T.',
        rating: 4,
        comment: 'Atendimento de qualidade. Ambiente profissional e acolhedor.',
      ),
    ],
  ),
  Clinic(
    name: 'Clínica Escola de Psicologia e Nutrição FAT',
    address: 'R. Brg. Eduardo Gomes - Ponto Central, Feira de Santana - BA, 44076-060',
    placeId: 'ChIJI69BpJw3FAcR-qdDaAmdvQk',
    lat: -12.251410,
    lng: -38.954215,
    phone: '',
    about:
        'Clínica escola da Faculdade Anísio Teixeira, oferecendo atendimento de qualidade a preços acessíveis. Os atendimentos são realizados por alunos sob supervisão de profissionais experientes.',
    rating: 4.5,
    reviewCount: 38,
    specialties: ['Psicologia Clínica', 'Triagem Psicológica', 'Avaliação Psicológica'],
    topics: ['Ansiedade', 'Depressão', 'Terapia Infantil'],
    reviews: [
      Review(
        reviewerName: 'Juliana A.',
        rating: 5,
        comment: 'Ótimo atendimento e custo acessível. Fui muito bem recebida.',
      ),
      Review(
        reviewerName: 'Marcos S.',
        rating: 4,
        comment: 'Bom atendimento. Os estagiários são bem preparados e supervisionados.',
      ),
    ],
  ),
  Clinic(
    name: 'Consultório de psicologia - Jamile Oliveira',
    address:
        'Edifício Euterpe feirense - Rua Conselheiro Franco - Centro, Feira de Santana - BA, 44002-272',
    placeId: 'ChIJ8xPAx1o3FAcRp09wnmZNnEU',
    lat: -12.259223,
    lng: -38.965842,
    phone: '',
    about:
        'Atendimento clínico individual com foco em saúde mental e qualidade de vida. Trabalha com adultos em processo de autoconhecimento e superação.',
    rating: 5.0,
    reviewCount: 17,
    specialties: ['Ansiedade', 'Luto', 'Autoconhecimento'],
    topics: ['Ansiedade', 'Luto', 'Autoconhecimento'],
    reviews: [
      Review(
        reviewerName: 'Camila N.',
        rating: 5,
        comment: 'Jamile é uma profissional excepcional. Me sinto muito mais leve depois das sessões.',
      ),
      Review(
        reviewerName: 'Diego C.',
        rating: 5,
        comment: 'Atendimento perfeito, com escuta ativa e muito acolhimento.',
      ),
    ],
  ),
  Clinic(
    name: 'Psicóloga Raqueline Portela',
    address:
        'Avenida Center - Av. Getúlio Vargas, 471 - sala 105 Ala B 1 andar - Centro, Feira de Santana - BA, 44100-000',
    placeId: 'ChIJe_00mp03FAcR3AM-egyhtX4',
    lat: -12.257551,
    lng: -38.961845,
    phone: '',
    about:
        'Consultório com atendimento presencial e online, voltado ao cuidado da saúde emocional de adultos. Abordagem acolhedora e personalizada para cada paciente.',
    rating: 4.6,
    reviewCount: 29,
    specialties: ['Depressão', 'Burnout', 'Terapia Online'],
    topics: ['Depressão', 'Burnout', 'Ansiedade'],
    reviews: [
      Review(
        reviewerName: 'Larissa P.',
        rating: 5,
        comment: 'A terapia online com Raqueline é incrível. Super comprometida.',
      ),
      Review(
        reviewerName: 'Roberto F.',
        rating: 4,
        comment: 'Profissional atenciosa. O atendimento faz real diferença no meu dia a dia.',
      ),
    ],
  ),
  Clinic(
    name: 'Psicóloga Lorena Vitoria',
    address: 'R. Leolinda Bacelar Lima, 20 - Centro, Feira de Santana - BA, 44001-240',
    placeId: 'ChIJi1A4XRU3FAcRRUHQqThUAtw',
    lat: -12.260136,
    lng: -38.964789,
    phone: '',
    about:
        'Acompanhamento psicológico individual com foco em saúde emocional e desenvolvimento pessoal. Ambiente seguro e sigiloso para um processo terapêutico genuíno.',
    rating: 4.8,
    reviewCount: 12,
    specialties: ['Autoestima', 'Relacionamentos', 'Ansiedade Social'],
    topics: ['Autoestima', 'Casal', 'Ansiedade'],
    reviews: [
      Review(
        reviewerName: 'Ana L.',
        rating: 5,
        comment: 'Lorena tem um dom especial para ouvir e orientar. Recomendo demais!',
      ),
      Review(
        reviewerName: 'Carlos S.',
        rating: 5,
        comment: 'Espaço acolhedor e profissional muito dedicada. Ótima experiência.',
      ),
    ],
  ),
  Clinic(
    name: 'Dra. Roberta Machado',
    address: 'R. Osvaldo Cruz, 106 - A, Feira de Santana - BA, 44001-288',
    placeId: 'ChIJmW37Jc83FAcRcMAODteWvuw',
    lat: -12.261250,
    lng: -38.963174,
    phone: '',
    about:
        'Atendimento psicológico clínico com ênfase em transtornos de humor e ansiedade. Vasta experiência no cuidado com a saúde mental de adultos e jovens adultos.',
    rating: 4.7,
    reviewCount: 33,
    specialties: ['Transtornos de Humor', 'Ansiedade', 'Terapia Breve'],
    topics: ['Ansiedade', 'Depressão', 'Burnout'],
    reviews: [
      Review(
        reviewerName: 'Mariana C.',
        rating: 5,
        comment: 'Dra. Roberta é extremamente competente. O tratamento foi transformador.',
      ),
      Review(
        reviewerName: 'Thiago M.',
        rating: 4,
        comment: 'Atendimento de qualidade. Profissional pontual e muito dedicada.',
      ),
    ],
  ),
];
