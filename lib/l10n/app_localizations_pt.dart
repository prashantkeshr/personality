// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Personality';

  @override
  String get navHome => 'Início';

  @override
  String get navHealth => 'Saúde';

  @override
  String get navAnalyze => 'Analisar';

  @override
  String get navCoach => 'Coach';

  @override
  String get navStyle => 'Estilo';

  @override
  String get todayTitle => 'Hoje';

  @override
  String get homeEmptyTitle => 'O seu dia começa aqui';

  @override
  String get homeEmptyBody =>
      'O seu plano diário e o seu progresso aparecerão aqui à medida que os recursos de acompanhamento ficarem disponíveis.';

  @override
  String get sectionFeatures => 'Recursos';

  @override
  String get healthIntro =>
      'Acompanhe o seu corpo, alimentação, sono e atividade diária.';

  @override
  String get analyzeIntro =>
      'Análise com a câmera no próprio aparelho. As imagens são processadas no seu celular e descartadas.';

  @override
  String get coachIntro =>
      'As recomendações vêm de regras transparentes. O Coach com IA opcional pode explicá-las.';

  @override
  String get styleIntro =>
      'Roupas, cores e looks com base nas suas medidas e preferências.';

  @override
  String get featureStateAvailable => 'Disponível';

  @override
  String get featureStateBeta => 'Beta';

  @override
  String get featureStateComingSoon => 'Em breve';

  @override
  String get featureStateDeviceRequired => 'Não compatível com este aparelho';

  @override
  String get featureStateModelRequired => 'Requer um modelo';

  @override
  String get featureStateOnlineRequired => 'Requer internet';

  @override
  String get featureStatePremium => 'Premium';

  @override
  String get featureProfile => 'Perfil';

  @override
  String get featureHeight => 'Altura';

  @override
  String get featureBodyMeasurements => 'Medidas do corpo';

  @override
  String get featureWeight => 'Peso';

  @override
  String get featureWater => 'Água';

  @override
  String get featureMeals => 'Refeições';

  @override
  String get featureSleep => 'Sono';

  @override
  String get featureActivity => 'Atividade';

  @override
  String get featureExercise => 'Exercício';

  @override
  String get featureHabits => 'Hábitos';

  @override
  String get featureRoutines => 'Rotinas';

  @override
  String get featureReminders => 'Lembretes';

  @override
  String get featureProgress => 'Progresso';

  @override
  String get featureCameraHeight => 'Altura estimada pela câmera';

  @override
  String get featurePosture => 'Análise de postura';

  @override
  String get featureExerciseTracking => 'Acompanhamento de exercício';

  @override
  String get featureFace => 'Análise facial';

  @override
  String get featureStyle => 'Recomendações de estilo';

  @override
  String get featureWardrobe => 'Guarda-roupa';

  @override
  String get featureAiCoach => 'Coach com IA';

  @override
  String get featureHealthIntegration => 'Dados conectados';

  @override
  String get featureBackup => 'Backup criptografado';

  @override
  String get featureCommerce => 'Compras';

  @override
  String get onboardingWelcomeTitle => 'Um espaço privado para o seu bem-estar';

  @override
  String get onboardingWelcomeBody =>
      'Acompanhe corpo, saúde, hábitos e estilo num só lugar. Tudo funciona offline.';

  @override
  String get onboardingPrivacyTitle => 'Os seus dados ficam neste aparelho';

  @override
  String get onboardingPrivacyEncrypted =>
      'Os registros ficam guardados num banco de dados criptografado neste celular.';

  @override
  String get onboardingPrivacyCamera =>
      'A análise com a câmera acontece no aparelho. As imagens não são guardadas, a menos que você escolha.';

  @override
  String get onboardingPrivacyAccount => 'Não é preciso criar conta.';

  @override
  String get onboardingPrivacyAi =>
      'A IA é opcional. O app funciona por completo sem ela.';

  @override
  String get onboardingPrefsTitle => 'Defina as suas preferências';

  @override
  String get onboardingPrefsBody =>
      'Pode alterá-las a qualquer momento em Configurações.';

  @override
  String onboardingStep(int current, int total) {
    return 'Passo $current de $total';
  }

  @override
  String get actionNext => 'Avançar';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionGetStarted => 'Começar';

  @override
  String get actionRetry => 'Tentar de novo';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsUnits => 'Unidades';

  @override
  String get unitsMetric => 'Métrico (cm, kg, L)';

  @override
  String get unitsImperial => 'Imperial (ft/in, lb, oz)';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Idioma do aparelho';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get settingsPrivacy => 'Privacidade';

  @override
  String get privacyStorageSummary =>
      'Os seus dados ficam guardados só neste aparelho, num banco de dados criptografado.';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get wellnessDisclaimer =>
      'O Personality apoia hábitos de bem-estar e estilo de vida. Não oferece aconselhamento nem diagnóstico médico.';

  @override
  String get settingsSaveError =>
      'Não foi possível salvar a configuração. Tente de novo.';

  @override
  String get startupErrorTitle => 'Não foi possível abrir os seus dados';

  @override
  String get startupErrorBody =>
      'O Personality não conseguiu abrir o armazenamento seguro. Os seus dados não foram alterados.';

  @override
  String get featureBodyProportions => 'Proporções do corpo';

  @override
  String get sourceUserEntered => 'Manual';

  @override
  String get sourceCameraDerived => 'Estimativa da câmera';

  @override
  String get sourceDeviceDerived => 'Aparelho';

  @override
  String get sourceHealthPlatform => 'Plataforma de saúde';

  @override
  String get sourceCalculated => 'Calculado';

  @override
  String get sourceImported => 'Importado';

  @override
  String get sourceAiGenerated => 'Gerado por IA';

  @override
  String get confidenceLow => 'Confiança baixa';

  @override
  String get confidenceMedium => 'Confiança média';

  @override
  String get confidenceHigh => 'Confiança alta';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueKg(String value) {
    return '$value kg';
  }

  @override
  String valueLb(String value) {
    return '$value lb';
  }

  @override
  String valueIn(String value) {
    return '$value in';
  }

  @override
  String valueFtIn(String feet, String inches) {
    return '$feet ft $inches in';
  }

  @override
  String get unitCmShort => 'cm';

  @override
  String get unitKgShort => 'kg';

  @override
  String get unitLbShort => 'lb';

  @override
  String get unitInShort => 'in';

  @override
  String get unitFtShort => 'ft';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get deleteRecordTitle => 'Excluir este registro?';

  @override
  String get deleteRecordBody =>
      'Isto remove o registro deste aparelho para sempre.';

  @override
  String get recordSaveError => 'Não foi possível salvar. Tente de novo.';

  @override
  String get loadErrorTitle => 'Não foi possível carregar';

  @override
  String get loadErrorBody =>
      'Não foi possível carregar estas informações. Os seus dados não foram alterados.';

  @override
  String get fieldDate => 'Data';

  @override
  String get fieldNotes => 'Notas (opcional)';

  @override
  String get fieldMethod => 'Como foi medido?';

  @override
  String get methodSelfMeasured => 'Medi eu mesmo';

  @override
  String get methodMeasuredByOther => 'Outra pessoa mediu';

  @override
  String get methodProfessional => 'Medição profissional';

  @override
  String get methodScale => 'Balança';

  @override
  String get methodEstimated => 'Minha estimativa';

  @override
  String get validationRequired => 'Digite um valor';

  @override
  String validationRange(String min, String max) {
    return 'Digite um valor entre $min e $max';
  }

  @override
  String get historyTitle => 'Histórico';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileIntro => 'Tudo aqui é opcional e fica neste aparelho.';

  @override
  String get profileName => 'Nome (opcional)';

  @override
  String get profileAgeRange => 'Faixa etária';

  @override
  String get profileActivityLevel => 'Nível de atividade';

  @override
  String get profileGoals => 'Objetivos';

  @override
  String get notSpecified => 'Não informado';

  @override
  String get profileSaved => 'Perfil salvo';

  @override
  String get ageUnder18 => 'Menos de 18';

  @override
  String get age18to24 => '18–24';

  @override
  String get age25to34 => '25–34';

  @override
  String get age35to44 => '35–44';

  @override
  String get age45to54 => '45–54';

  @override
  String get age55to64 => '55–64';

  @override
  String get age65plus => '65+';

  @override
  String get activitySedentary => 'Quase sempre sentado';

  @override
  String get activityLight => 'Pouco ativo';

  @override
  String get activityModerate => 'Moderadamente ativo';

  @override
  String get activityActive => 'Ativo';

  @override
  String get activityVeryActive => 'Muito ativo';

  @override
  String get goalPosture => 'Postura';

  @override
  String get goalWeightManagement => 'Controle de peso';

  @override
  String get goalFitness => 'Condicionamento físico';

  @override
  String get goalFlexibility => 'Flexibilidade e mobilidade';

  @override
  String get goalHydration => 'Hidratação';

  @override
  String get goalSleep => 'Sono';

  @override
  String get goalHabits => 'Hábitos e rotinas';

  @override
  String get goalStyle => 'Estilo';

  @override
  String get goalGrooming => 'Cuidados pessoais';

  @override
  String get heightTitle => 'Altura';

  @override
  String get heightEmpty =>
      'Adicione a sua altura para melhorar as recomendações de proporções e roupas.';

  @override
  String get heightAdd => 'Adicionar altura';

  @override
  String get heightPrimary => 'Altura principal';

  @override
  String get heightPinnedNote =>
      'Você escolheu este registro como a sua altura principal.';

  @override
  String get heightLatestManualNote =>
      'Usando a sua medição manual mais recente.';

  @override
  String get heightVariationNote =>
      'A altura varia naturalmente cerca de 1–2 cm ao longo do dia. Pequenas diferenças entre registros são normais e não contam como crescimento.';

  @override
  String get heightSetPrimary => 'Usar como principal';

  @override
  String get weightTitle => 'Peso';

  @override
  String get weightEmpty =>
      'Adicione o seu primeiro registro de peso para começar a ver tendências.';

  @override
  String get weightAdd => 'Adicionar peso';

  @override
  String get weightLatest => 'Último';

  @override
  String get weightGoalRange => 'Faixa de objetivo';

  @override
  String get weightGoalNotSet => 'Sem faixa de objetivo';

  @override
  String get weightSetGoal => 'Definir';

  @override
  String get weightGoalMin => 'De';

  @override
  String get weightGoalMax => 'Até';

  @override
  String get weightGoalInvalid =>
      'O segundo valor deve ser maior que o primeiro.';

  @override
  String get weightClearGoal => 'Limpar';

  @override
  String get goalBelow => 'Abaixo da sua faixa de objetivo';

  @override
  String get goalWithin => 'Dentro da sua faixa de objetivo';

  @override
  String get goalAbove => 'Acima da sua faixa de objetivo';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mês';

  @override
  String get periodQuarter => '3 meses';

  @override
  String weightTrendChange(String change) {
    return 'Mudança na média de 7 dias neste período: $change';
  }

  @override
  String get weightTrendInsufficient =>
      'Adicione pelo menos dois registros neste período para ver uma tendência.';

  @override
  String weightChartLabel(int count) {
    return 'Gráfico de peso com $count registros';
  }

  @override
  String get weightAverageLegend => 'Média de 7 dias';

  @override
  String get weightEntriesLegend => 'Registros';

  @override
  String get measurementsTitle => 'Medidas do corpo';

  @override
  String get measurementsIntro =>
      'Opcional. Usado para proporções do corpo e caimento das roupas. Meça sobre roupa leve com uma fita flexível.';

  @override
  String get measurementNotRecorded => 'Não registrado';

  @override
  String get measurementAdd => 'Adicionar medida';

  @override
  String get measurementCustom => 'Medida personalizada';

  @override
  String get measurementCustomLabel => 'Nome da medida';

  @override
  String get measurementType => 'Medida';

  @override
  String get mShoulderWidth => 'Largura dos ombros';

  @override
  String get mChest => 'Peito';

  @override
  String get mWaist => 'Cintura';

  @override
  String get mHip => 'Quadril';

  @override
  String get mNeck => 'Pescoço';

  @override
  String get mArmLength => 'Comprimento do braço';

  @override
  String get mLegLength => 'Comprimento da perna';

  @override
  String get mTorsoLength => 'Comprimento do tronco';

  @override
  String get mInseam => 'Entreperna';

  @override
  String get mShoulderWidthHelp =>
      'Em linha reta pelas costas, da ponta de um ombro à do outro.';

  @override
  String get mChestHelp =>
      'Ao redor da parte mais larga do peito, com a fita nivelada.';

  @override
  String get mWaistHelp => 'Ao redor da cintura natural, logo acima do umbigo.';

  @override
  String get mHipHelp => 'Ao redor da parte mais larga do quadril.';

  @override
  String get mNeckHelp => 'Ao redor da base do pescoço.';

  @override
  String get mArmLengthHelp =>
      'Da ponta do ombro até o pulso, com o braço relaxado.';

  @override
  String get mLegLengthHelp =>
      'Do osso do quadril até o chão, pela lateral externa da perna.';

  @override
  String get mTorsoLengthHelp => 'Do alto do ombro até a cintura natural.';

  @override
  String get mInseamHelp =>
      'Da virilha até o chão, pela parte interna da perna.';

  @override
  String get proportionsTitle => 'Proporções do corpo';

  @override
  String get proportionsIntro =>
      'Descrições neutras usadas para caimento das roupas e sugestões de silhueta.';

  @override
  String get proportionsDisclaimer =>
      'Não são avaliações de saúde nem de aparência, e não existe forma ideal.';

  @override
  String get proportionsEmpty =>
      'Adicione a sua altura e algumas medidas para ver as suas proporções.';

  @override
  String proportionsMissing(String items, String metric) {
    return 'Adicione $items para ver $metric.';
  }

  @override
  String proportionsBasedOn(String inputs) {
    return 'Com base em: $inputs';
  }

  @override
  String get proportionsAddMeasurements => 'Medidas';

  @override
  String get metricLegLine => 'Linha das pernas';

  @override
  String get metricShoulderBreadth => 'Largura dos ombros';

  @override
  String get metricUpperTaper => 'Diferença peito-cintura';

  @override
  String get metricHipBalance => 'Equilíbrio quadril-peito';

  @override
  String get descShorterLegLine =>
      'Linha das pernas mais curta em relação à altura';

  @override
  String get descBalancedLegLine => 'Linha das pernas equilibrada';

  @override
  String get descLongerLegLine =>
      'Linha das pernas mais longa em relação à altura';

  @override
  String get descNarrowerShoulders =>
      'Ombros mais estreitos em relação à altura';

  @override
  String get descAverageShoulders =>
      'Largura dos ombros na faixa média para a sua altura';

  @override
  String get descBroaderShoulders => 'Ombros mais largos em relação à altura';

  @override
  String get descStraightTaper => 'Linha mais reta no tronco';

  @override
  String get descModerateTaper => 'Afunilamento moderado do peito à cintura';

  @override
  String get descPronouncedTaper => 'Afunilamento acentuado do peito à cintura';

  @override
  String get descChestFuller => 'O peito mede mais que o quadril';

  @override
  String get descBalancedChestHip => 'Peito e quadril medem parecido';

  @override
  String get descHipsFuller => 'O quadril mede mais que o peito';

  @override
  String valueFlOz(String value) {
    return '$value fl oz';
  }

  @override
  String valueLitres(String value) {
    return '$value L';
  }

  @override
  String valueMl(String value) {
    return '$value ml';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String valueMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String valueSteps(String value) {
    return '$value passos';
  }

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMiles(String value) {
    return '$value mi';
  }

  @override
  String valueKcal(int value) {
    return '$value kcal';
  }

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealSnack => 'Lanche';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get mealCustom => 'Outra';

  @override
  String get activityWalking => 'Caminhada';

  @override
  String get activityRunning => 'Corrida';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activitySwimming => 'Natação';

  @override
  String get activitySports => 'Esportes';

  @override
  String get activityOther => 'Outra atividade';

  @override
  String get exNeck => 'Pescoço';

  @override
  String get exShoulder => 'Ombro';

  @override
  String get exUpperBack => 'Parte superior das costas';

  @override
  String get exLowerBack => 'Lombar';

  @override
  String get exCore => 'Core';

  @override
  String get exMobility => 'Mobilidade';

  @override
  String get exYoga => 'Ioga';

  @override
  String get exStretching => 'Alongamento';

  @override
  String get exPosture => 'Postura';

  @override
  String get exGeneralFitness => 'Condicionamento geral';

  @override
  String get exStrength => 'Força';

  @override
  String get exCardio => 'Cardio';

  @override
  String get targetOutOfRange => 'Este valor está fora da faixa permitida.';

  @override
  String get targetsTitle => 'Metas diárias';

  @override
  String get targetsIntro =>
      'São pontos de partida que você pode mudar quando quiser. Não são recomendações médicas.';

  @override
  String get unitLitreShort => 'L';

  @override
  String get unitFlOzShort => 'fl oz';

  @override
  String get unitHoursShort => 'h';

  @override
  String get unitMinutesShort => 'min';

  @override
  String get unitMlShort => 'ml';

  @override
  String get unitKmShort => 'km';

  @override
  String get unitMiShort => 'mi';

  @override
  String get stepsLabel => 'Passos';

  @override
  String get activeMinutesLabel => 'Minutos ativos';

  @override
  String get waterCustom => 'Quantidade personalizada';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get actionEdit => 'Editar';

  @override
  String ofTarget(String value) {
    return 'Meta: $value';
  }

  @override
  String get lastSevenDays => 'Últimos 7 dias';

  @override
  String weekChartLabel(String metric) {
    return '$metric dos últimos 7 dias';
  }

  @override
  String get todayEntries => 'Registros de hoje';

  @override
  String get waterEmpty => 'Nenhuma água registrada hoje.';

  @override
  String get mealAdd => 'Registrar refeição';

  @override
  String get mealsEmpty =>
      'Registre o que come, com as suas palavras. Calorias são opcionais.';

  @override
  String get mealType => 'Refeição';

  @override
  String get mealCustomName => 'Nome (opcional)';

  @override
  String get mealFood => 'O que você comeu?';

  @override
  String get mealQuantity => 'Quantidade (opcional)';

  @override
  String get mealCalories => 'Calorias (opcional)';

  @override
  String get mealCaloriesHelp => 'Só se quiser acompanhá-las.';

  @override
  String get fieldTime => 'Hora';

  @override
  String get sleepAdd => 'Registrar sono';

  @override
  String get sleepLastNight => 'Ontem à noite';

  @override
  String get sleepConsistencyInsufficient =>
      'Registre pelo menos duas noites nesta semana para ver a regularidade da sua hora de dormir.';

  @override
  String sleepConsistency(int minutes) {
    return 'A sua hora de dormir variou cerca de $minutes min nesta semana.';
  }

  @override
  String get sleepDisclaimer =>
      'O acompanhamento do sono aqui serve para o seu conhecimento pessoal e não avalia distúrbios do sono.';

  @override
  String get sleepEmpty => 'Nenhum sono registrado ainda.';

  @override
  String get sleepWakeBeforeBed =>
      'A hora de acordar deve ser depois da hora de dormir.';

  @override
  String get sleepTooLong => 'Um registro de sono não pode passar de 24 horas.';

  @override
  String get sleepBedtime => 'Hora de dormir';

  @override
  String get sleepWakeTime => 'Hora de acordar';

  @override
  String sleepDurationPreview(String duration) {
    return 'Duração: $duration';
  }

  @override
  String get activityAdd => 'Registrar atividade';

  @override
  String get activeMinutesNote =>
      'Os minutos ativos incluem atividades e sessões de exercício.';

  @override
  String get activityEmpty =>
      'Nenhuma atividade registrada ainda. A importação automática de passos do Health Connect virá mais tarde.';

  @override
  String get activityNeedsValue =>
      'Informe passos, uma duração ou uma distância.';

  @override
  String get activityKindLabel => 'Atividade';

  @override
  String get durationLabel => 'Duração';

  @override
  String get distanceLabel => 'Distância (opcional)';

  @override
  String get exerciseAdd => 'Registrar exercício';

  @override
  String get exerciseEmpty =>
      'Registre o exercício que fez. Uma biblioteca de exercícios guiados virá numa próxima atualização.';

  @override
  String get exerciseThisWeek => 'Esta semana';

  @override
  String setsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String get exerciseName => 'Exercício';

  @override
  String get exerciseCategory => 'Categoria';

  @override
  String get setsLabel => 'Séries (opcional)';

  @override
  String get repsLabel => 'Repetições (opcional)';

  @override
  String get habitAdd => 'Adicionar hábito';

  @override
  String get habitEdit => 'Editar hábito';

  @override
  String get habitsEmpty =>
      'Adicione um pequeno hábito que queira repetir e escolha os dias em que vale.';

  @override
  String habitsTodaySummary(int done, int total) {
    return 'Hoje você concluiu $done de $total hábitos.';
  }

  @override
  String get habitsNotToday => 'Não está previsto hoje';

  @override
  String habitWeekAdherence(int done, int total) {
    return '$done de $total nesta semana';
  }

  @override
  String get habitSkippedToday => 'Pulado hoje';

  @override
  String get habitSkip => 'Pular';

  @override
  String get habitUndo => 'Desfazer';

  @override
  String get habitArchive => 'Arquivar';

  @override
  String get habitName => 'Hábito';

  @override
  String get habitDays => 'Dias';

  @override
  String get habitDaysRequired => 'Escolha pelo menos um dia.';

  @override
  String get habitsNoneToday => 'Nenhum hoje';

  @override
  String get homeBodyTitle => 'Corpo';

  @override
  String mealsLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count refeições',
      one: '1 refeição',
      zero: 'Nenhuma registrada',
    );
    return '$_temp0';
  }

  @override
  String get planTitle => 'Plano de hoje';

  @override
  String get routineNew => 'Nova rotina';

  @override
  String get routinesEmpty =>
      'Crie uma rotina diária com horários para água, refeições, movimento e descanso. Os lembretes são opcionais.';

  @override
  String get routineFromExample => 'Começar com um exemplo';

  @override
  String get templateRoutineName => 'Minha rotina diária';

  @override
  String get newRoutineName => 'Nova rotina';

  @override
  String routineItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Sem itens',
    );
    return '$_temp0';
  }

  @override
  String get everyDay => 'Todos os dias';

  @override
  String get routineNotFound => 'Esta rotina não existe mais.';

  @override
  String get actionDuplicate => 'Duplicar';

  @override
  String routineCopyName(String name) {
    return '$name (cópia)';
  }

  @override
  String get routineAddItem => 'Adicionar item';

  @override
  String get routinePaused => 'Pausada — fora do plano de hoje.';

  @override
  String get routineNoItems =>
      'Ainda sem itens. Adicione horários para o que quer fazer.';

  @override
  String get reminderOn => 'Lembrar-me';

  @override
  String get reminderOff => 'Sem lembrete';

  @override
  String get routineName => 'Nome da rotina';

  @override
  String get routineItemTitle => 'O quê';

  @override
  String get routineItemKind => 'Tipo';

  @override
  String get kindWake => 'Acordar';

  @override
  String get kindMeal => 'Refeição';

  @override
  String get kindWindDown => 'Desacelerar';

  @override
  String get kindCustom => 'Outro';

  @override
  String get templatePostureBreak => 'Pausa para a postura';

  @override
  String get remindersChannelName => 'Lembretes de rotina';

  @override
  String get remindersChannelDescription =>
      'Lembretes dos itens das suas rotinas';

  @override
  String get reminderActionDone => 'Feito';

  @override
  String get reminderActionSnooze => 'Adiar 10 min';

  @override
  String reminderBody(String time) {
    return 'Previsto para $time';
  }

  @override
  String get planEmpty =>
      'Nada planejado para hoje. Crie uma rotina para ver o seu plano aqui.';

  @override
  String planSummary(int done, int total) {
    return 'Concluídos $done de $total planejados';
  }

  @override
  String planBreakdown(int skipped, int missed, int moved, int open) {
    return 'Pulados $skipped · Perdidos $missed · Movidos $moved · Restantes $open';
  }

  @override
  String get planWeekAdherence => 'Plano cumprido, últimos 7 dias (%)';

  @override
  String get planAdherenceNote =>
      'Mostra quanto do seu plano aconteceu. É separado de resultados de saúde como água ou passos.';

  @override
  String get planUpcoming => 'Próximos';

  @override
  String get planDue => 'Agora';

  @override
  String get planDone => 'Feito';

  @override
  String get planSkipped => 'Pulado';

  @override
  String get planMissed => 'Perdido';

  @override
  String planMovedFrom(String time) {
    return 'movido de $time';
  }

  @override
  String get planReschedule => 'Mudar para outro horário';

  @override
  String get planHomeEmpty => 'Ainda sem plano para hoje';

  @override
  String get planAllDone => 'Nada mais para hoje';

  @override
  String planNext(String title, String time) {
    return 'Próximo: $title — $time';
  }

  @override
  String get suggestionTitle => 'Sugestão';

  @override
  String suggestionMissed(String title, String time, int count, int total) {
    return '$title às $time foi perdido em $count dos últimos $total dias agendados.';
  }

  @override
  String suggestionLate(String title, String time, int count, int total) {
    return '$title às $time costumou ser feito mais tarde — em $count dos últimos $total dias agendados.';
  }

  @override
  String suggestionRescheduled(String title, String time, int count) {
    return 'Você mudou $title das $time $count vezes recentemente.';
  }

  @override
  String suggestionQuestion(String time) {
    return 'Mudar para $time?';
  }

  @override
  String suggestionAccept(String time) {
    return 'Mudar para $time';
  }

  @override
  String get suggestionDismiss => 'Manter o horário';

  @override
  String get notificationsBlocked =>
      'As notificações estão desativadas para este app. O seu plano continua a funcionar aqui; ative as notificações nas configurações do Android para receber lembretes.';

  @override
  String get remindersEnable => 'Lembretes de rotina';

  @override
  String get remindersOnNote =>
      'Você será lembrado dos itens de rotina com lembrete ativado.';

  @override
  String get remindersOffNote =>
      'Desativado. O seu plano continua disponível no app.';

  @override
  String get remindersAdaptive => 'Sugestões de horário';

  @override
  String get remindersAdaptiveNote =>
      'Sugere um horário melhor quando um item é perdido ou feito tarde com frequência. Nada muda sem a sua aprovação.';

  @override
  String get remindersTimingNote =>
      'Para poupar bateria, o Android pode entregar lembretes com alguns minutos de atraso.';

  @override
  String get remindersNext => 'Próximos lembretes';

  @override
  String get remindersNoneUpcoming => 'Nenhum lembrete nos próximos dois dias.';

  @override
  String get featureCameraCheck => 'Teste da câmera';

  @override
  String get cameraSwitch => 'Trocar de câmera';

  @override
  String get cameraUnavailable =>
      'Sem acesso à câmera. O registro manual continua disponível.';

  @override
  String get cameraPermissionDenied =>
      'O acesso à câmera não foi permitido. O registro manual continua disponível. Para usar a câmera, permita-a para o Personality nas configurações do Android.';

  @override
  String get cameraFailed =>
      'Não foi possível iniciar a câmera. Feche outros apps que a estejam usando e tente de novo.';

  @override
  String get cameraIntro =>
      'Verifique a câmera e a iluminação. As imagens são analisadas neste celular e descartadas — nada é guardado nem enviado.';

  @override
  String get cameraStart => 'Ligar câmera';

  @override
  String get cameraStop => 'Desligar câmera';

  @override
  String get cameraPrivacyNote =>
      'As imagens da câmera ficam na memória só enquanto são analisadas e depois são descartadas. A câmera para quando você sai desta tela ou troca de app.';

  @override
  String get cameraProcessingOnDevice => 'Processando no aparelho';

  @override
  String get cameraWaiting => 'Aguardando imagens…';

  @override
  String get cameraLighting => 'Iluminação';

  @override
  String get cameraAnalysisRate => 'Análise';

  @override
  String cameraFramesStats(int fps, int frames) {
    return '$fps imagens por segundo · $frames analisadas';
  }

  @override
  String get poseModelRequired =>
      'A análise de postura precisa do modelo de pose, que virá numa próxima atualização. Os testes de luz e câmera já funcionam.';

  @override
  String get poseNoPerson =>
      'Nenhuma pessoa detectada. Entre no enquadramento.';

  @override
  String get posePersonDetected => 'Pessoa detectada';

  @override
  String get poseReposition =>
      'Entre na guia para que o seu corpo todo fique visível.';

  @override
  String get poseHoldStill => 'Fique parado por um momento.';

  @override
  String get cameraPowerMode => 'Modo de energia da câmera';

  @override
  String get powerLow => 'Economia';

  @override
  String get powerStandard => 'Padrão';

  @override
  String get powerHigh => 'Alta precisão';

  @override
  String get powerLowNote =>
      'Resolução menor, 5 análises por segundo. Poupa bateria; os resultados podem ser menos estáveis.';

  @override
  String get powerStandardNote =>
      'Resolução equilibrada, 10 análises por segundo. Recomendado para a maioria dos celulares.';

  @override
  String get powerHighNote =>
      'Resolução maior, 15 análises por segundo. Resultados mais estáveis; gasta mais bateria e pode aquecer o celular.';

  @override
  String get lightingGood => 'Boa luz';

  @override
  String get lightingDim => 'Pouca luz';

  @override
  String get lightingTooDark => 'Escuro demais';

  @override
  String get lightingTooBright => 'Claro demais';

  @override
  String get lightingLowContrast => 'Lente coberta?';

  @override
  String get lightingGoodAdvice => 'A iluminação está boa para a análise.';

  @override
  String get lightingDimAdvice =>
      'Dá para usar, mas com mais luz os resultados ficam mais estáveis.';

  @override
  String get lightingTooDarkAdvice =>
      'Melhore a iluminação — acenda uma luz ou fique de frente para uma janela.';

  @override
  String get lightingTooBrightAdvice =>
      'Luz demais — evite ficar na frente de uma janela muito clara.';

  @override
  String get lightingLowContrastAdvice =>
      'A imagem está quase uniforme. Verifique se a lente não está coberta.';

  @override
  String get deviceInfoTitle => 'Este aparelho';

  @override
  String get deviceInfoSubtitle => 'Hardware e qualidade de processamento';

  @override
  String get deviceInfoIntro =>
      'O Personality ajusta a qualidade da câmera e da análise ao hardware deste celular. Só são lidos dados do hardware; nenhum identificador é coletado.';

  @override
  String get deviceUnknownNote =>
      'Não foi possível ler os dados do hardware, então são usadas as configurações mais conservadoras.';

  @override
  String get deviceTier => 'Nível de desempenho';

  @override
  String get tierHigh => 'Alto';

  @override
  String get tierMedium => 'Médio';

  @override
  String get tierLow => 'Básico';

  @override
  String get deviceRam => 'Memória';

  @override
  String get deviceCores => 'Núcleos do processador';

  @override
  String get deviceAndroid => 'Versão do Android';

  @override
  String get deviceStorage => 'Armazenamento livre';

  @override
  String get deviceCamera => 'Câmera';

  @override
  String get deviceProcessing => 'Processamento';

  @override
  String get deviceAnalysisRate => 'Taxa de análise padrão';

  @override
  String get deviceCameraResolution => 'Resolução padrão da câmera';

  @override
  String get deviceLocalAi => 'Suporta IA local opcional';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get unknownValue => 'Desconhecido';

  @override
  String valueGb(String value) {
    return '$value GB';
  }

  @override
  String valueFps(int fps) {
    return '$fps por segundo';
  }

  @override
  String get privacyCameraSummary =>
      'A análise com a câmera acontece neste celular. As imagens nunca são guardadas nem enviadas, a menos que você escolha guardar uma foto.';

  @override
  String get pmHeadTilt => 'Inclinação da cabeça';

  @override
  String get pmShoulderLevel => 'Nível dos ombros';

  @override
  String get pmHipLevel => 'Nível do quadril';

  @override
  String get pmTorsoLean => 'Inclinação do tronco';

  @override
  String get pmKneeAlignment => 'Alinhamento dos joelhos';

  @override
  String get pmHeadForward => 'Posição da cabeça';

  @override
  String get bandAligned => 'Dentro da faixa habitual';

  @override
  String get bandSlight => 'Leve';

  @override
  String get bandNoticeable => 'Perceptível';

  @override
  String get dirNone => 'Centralizado';

  @override
  String get dirLeftHigher => 'Lado esquerdo mais alto';

  @override
  String get dirRightHigher => 'Lado direito mais alto';

  @override
  String get dirTiltLeft => 'Inclinada para a sua esquerda';

  @override
  String get dirTiltRight => 'Inclinada para a sua direita';

  @override
  String get dirKneeLeft => 'Maior no joelho esquerdo';

  @override
  String get dirKneeRight => 'Maior no joelho direito';

  @override
  String get dirLeanLeft => 'Inclinado para a sua esquerda';

  @override
  String get dirLeanRight => 'Inclinado para a sua direita';

  @override
  String get dirHeadAhead => 'Cabeça à frente dos ombros';

  @override
  String get dirLeanForward => 'Inclinado para a frente';

  @override
  String get dirLeanBack => 'Inclinado para trás';

  @override
  String get viewFront => 'Vista frontal';

  @override
  String get viewSide => 'Vista lateral';

  @override
  String get poseTooFar => 'Aproxime-se um pouco do celular.';

  @override
  String get poseTooClose => 'Afaste-se para que o corpo todo caiba na guia.';

  @override
  String get poseUnclearView =>
      'Fique de frente para a câmera ou totalmente de lado.';

  @override
  String get poseLowVisibility =>
      'O seu corpo não está bem visível. Roupas justas e um fundo liso ajudam.';

  @override
  String postureReady(String view) {
    return 'Pronto — $view detectada. Fique de pé naturalmente e toque em Analisar.';
  }

  @override
  String get postureAnalyze => 'Analisar';

  @override
  String get postureCapturing =>
      'Fique parado enquanto várias imagens são analisadas…';

  @override
  String get postureHistory => 'Histórico de postura';

  @override
  String get postureHistoryEmpty => 'Faça a sua primeira avaliação de postura.';

  @override
  String get postureIntro =>
      'Obtenha uma estimativa do alinhamento da cabeça, ombros, quadril e joelhos. A análise acontece neste celular; as imagens são descartadas.';

  @override
  String get postureTipPhone =>
      'Apoie o celular em pé, mais ou menos na altura da cintura.';

  @override
  String get postureTipDistance =>
      'Fique a 2–3 metros para que o corpo todo caiba.';

  @override
  String get postureTipLight =>
      'Use luz uniforme; evite uma janela clara atrás de você.';

  @override
  String get postureTipClothes =>
      'Roupas justas facilitam ver os pontos de referência.';

  @override
  String get postureTipViews =>
      'Fique de frente para a vista frontal, ou de lado para a posição da cabeça.';

  @override
  String get lensFront => 'Câmera frontal';

  @override
  String get lensBack => 'Câmera traseira';

  @override
  String get postureDisclaimer =>
      'Alinhamento estimado pela câmera para o seu conhecimento pessoal — não é uma avaliação médica nem da coluna. Em caso de dor ou dúvida, procure um profissional qualificado.';

  @override
  String get postureNotReliable =>
      'Não foi possível medir a postura com segurança.';

  @override
  String postureResultTitle(String view) {
    return 'Alinhamento estimado · $view';
  }

  @override
  String postureFramesUsed(int count) {
    return '$count imagens';
  }

  @override
  String get postureSaved => 'Avaliação de postura salva';

  @override
  String get postureSavedShort => 'Salvo';

  @override
  String get postureRetake => 'Refazer';

  @override
  String get postureSuggestions => 'Sugestões para você';

  @override
  String get postureLowConfidenceNote =>
      'Os resultados foram incertos, por isso não há sugestões. Tente de novo com mais luz e o corpo todo dentro da guia.';

  @override
  String postureChange(String change) {
    return '$change desde a última avaliação';
  }

  @override
  String postureFlaggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos para observar',
      one: '1 ponto para observar',
      zero: 'Tudo dentro da faixa habitual',
    );
    return '$_temp0';
  }

  @override
  String valueDegrees(String value) {
    return '$value°';
  }

  @override
  String get exerciseSafetyNote =>
      'São ideias gerais de mobilidade, não tratamento. Pare se algo doer.';

  @override
  String get whyThis => 'Por que isto?';

  @override
  String whyObserved(String metric, String degrees, String band) {
    return '$metric mediu $degrees° ($band) nesta avaliação.';
  }

  @override
  String get whyRepeated => 'A sua avaliação anterior também mostrou isto.';

  @override
  String get whyGoal => 'A postura é um dos seus objetivos.';

  @override
  String get whyMaintenance =>
      'Todos os alinhamentos estimados estavam na faixa habitual; pausas regulares ajudam a manter assim.';

  @override
  String alternativeLabel(String name) {
    return 'Alternativa: $name';
  }

  @override
  String get poseAnalysisFailed =>
      'Não foi possível analisar esta imagem no aparelho. Se continuar a acontecer, reinicie a câmera.';

  @override
  String get postureStepBack =>
      'Volte para a guia — a captura recomeça do zero.';

  @override
  String postureCountdown(int seconds) {
    return 'Começa em $seconds';
  }

  @override
  String get exerciseLibrary => 'Biblioteca de exercícios';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterCameraTracked => 'Com câmera';

  @override
  String get cameraTracked => 'Com câmera';

  @override
  String get howTo => 'Como fazer';

  @override
  String get trackWithCamera => 'Acompanhar com a câmera';

  @override
  String get logAsDone => 'Marcar como feito';

  @override
  String get savedToLog => 'Salvo no seu registro de exercícios';

  @override
  String repsValue(int count) {
    return '$count repetições';
  }

  @override
  String get trackingSetupFront =>
      'Apoie o celular em pé na altura da cintura, afaste-se 2–3 m e fique de frente para a câmera com o corpo todo visível.';

  @override
  String get trackingSetupSide =>
      'Coloque o celular ao seu lado, na altura do chão ou da cintura, para que veja o seu corpo todo de perfil.';

  @override
  String trackingTargetReps(int count) {
    return 'Meta: $count repetições';
  }

  @override
  String trackingTargetHold(int seconds) {
    return 'Meta: manter por $seconds segundos';
  }

  @override
  String get trackingReady =>
      'Pronto — toque em Começar e posicione-se durante a contagem.';

  @override
  String get trackingStart => 'Começar';

  @override
  String get trackingFinish => 'Terminar';

  @override
  String trackingOfReps(int count) {
    return 'de $count repetições';
  }

  @override
  String trackingOfSeconds(int seconds) {
    return 'de $seconds s';
  }

  @override
  String holdSecondsValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get trackingSummaryTitle => 'Resumo da sessão';

  @override
  String get trackingRepsDone => 'Repetições contadas';

  @override
  String get trackingHoldTime => 'Tempo em posição';

  @override
  String get trackingTargetReached => 'Meta atingida — muito bem.';

  @override
  String get trackingCountNote =>
      'Contado pela câmera deste celular. De vez em quando pode perder ou somar uma repetição.';

  @override
  String get saveToLog => 'Salvar no registro';

  @override
  String get trackingDone => 'Feito';

  @override
  String get cueStepIntoView =>
      'Entre no enquadramento para o corpo todo aparecer.';

  @override
  String get cueGoLower => 'Desça um pouco mais se for confortável.';

  @override
  String get cueKneesOverToes => 'Mantenha os joelhos alinhados com os pés.';

  @override
  String get cueChestUp => 'Mantenha o peito para cima.';

  @override
  String get cueRaiseHigher => 'Levante os braços um pouco mais.';

  @override
  String get cueRaiseEvenly => 'Levante os dois braços por igual.';

  @override
  String get cueLiftKneeHigher => 'Levante o joelho um pouco mais.';

  @override
  String get cueKeepBodyStraight =>
      'Mantenha uma linha reta dos ombros aos tornozelos.';

  @override
  String get cueGetIntoPosition => 'Fique em posição.';

  @override
  String get cueGoodForm => 'Muito bem — continue.';

  @override
  String get cueKeepGoing => 'Continue num ritmo constante.';

  @override
  String get faceHistory => 'Histórico facial';

  @override
  String get faceHistoryEmpty =>
      'Faça uma avaliação facial para ver aqui sugestões de estilo.';

  @override
  String get faceIntro =>
      'Estime o formato do seu rosto pelas proporções e receba ideias de cabelo, barba, óculos e cuidados.';

  @override
  String get facePrivacy =>
      'O seu rosto é analisado neste celular. Nenhuma foto é tirada nem guardada; só as proporções são salvas, e só se tocar em Salvar.';

  @override
  String get faceTipLight =>
      'Fique de frente para uma janela ou lâmpada para a luz cair por igual no rosto.';

  @override
  String get faceTipHair => 'Afaste o cabelo da testa e da linha do queixo.';

  @override
  String get faceTipStraight =>
      'Olhe direto para a câmera com expressão neutra e a cabeça reta.';

  @override
  String get faceDisclaimer =>
      'O formato do rosto é uma estimativa da câmera, usada só para ideias de estilo. Não diz nada sobre beleza, e cada rosto combina com muitos estilos.';

  @override
  String get faceNone => 'Nenhum rosto detectado. Olhe para a câmera.';

  @override
  String get faceMultiple =>
      'Há mais de um rosto visível. Garanta que só você aparece.';

  @override
  String get faceModelRequired =>
      'A análise facial não está disponível neste aparelho.';

  @override
  String get faceReady => 'Rosto detectado — toque em Analisar e fique parado.';

  @override
  String get faceTooFar => 'Aproxime um pouco o celular do rosto.';

  @override
  String get faceTooClose => 'Afaste um pouco o celular.';

  @override
  String get faceInGuide => 'Mantenha o rosto todo dentro do oval.';

  @override
  String get faceCapturing =>
      'Fique parado enquanto algumas imagens são medidas…';

  @override
  String get faceNotReliable =>
      'Não foi possível estimar o formato do rosto com segurança.';

  @override
  String get faceSaved => 'Avaliação facial salva';

  @override
  String get faceResultTitle => 'Formato de rosto estimado';

  @override
  String faceShapeBetween(String first, String second) {
    return '$first / $second';
  }

  @override
  String get faceLowConfidenceNote =>
      'A estimativa foi incerta, por isso não há sugestões de estilo. Tente de novo com luz uniforme e a cabeça reta.';

  @override
  String get shapeOval => 'Oval';

  @override
  String get shapeRound => 'Redondo';

  @override
  String get shapeSquare => 'Quadrado';

  @override
  String get shapeOblong => 'Alongado';

  @override
  String get shapeHeart => 'Coração';

  @override
  String get shapeDiamond => 'Diamante';

  @override
  String get ratioLengthWidth => 'Comprimento ÷ largura das maçãs';

  @override
  String get ratioForeheadCheek => 'Testa ÷ largura das maçãs';

  @override
  String get ratioJawCheek => 'Mandíbula ÷ largura das maçãs';

  @override
  String get styleHair => 'Cortes de cabelo';

  @override
  String get styleBeard => 'Estilos de barba';

  @override
  String get styleBeardNote => 'Se você tem ou quer ter barba.';

  @override
  String get styleGlasses => 'Armações de óculos';

  @override
  String get favoriteAdd => 'Adicionar aos favoritos';

  @override
  String get favoriteRemove => 'Remover dos favoritos';

  @override
  String get groomingTitle => 'Rotina simples de cuidados';

  @override
  String get groomingAddRoutine => 'Adicionar às minhas rotinas';

  @override
  String get groomingRoutineName => 'Cuidados pessoais';

  @override
  String get groomingRoutineAdded =>
      'Rotina de cuidados adicionada às suas rotinas';

  @override
  String faceBetweenNote(String shape) {
    return 'As suas proporções também se aproximam de $shape, por isso mostramos ideias para os dois:';
  }

  @override
  String get cardFlipHint => 'Toque para ver detalhes';

  @override
  String get tryOn => 'Experimentar';

  @override
  String get tryOnOpen => 'Experimentar óculos e estilos de barba';

  @override
  String get faceArtLegend =>
      'Cinza: formato de referência · Cor: as suas proporções';

  @override
  String get tryOnHint => 'Toque e segure a prévia para comparar sem o estilo.';

  @override
  String get tryOnComparing => 'Mostrando sem o estilo';

  @override
  String get tryOnNone => 'Nenhum';

  @override
  String get tryOnNote =>
      'Prévia ao vivo desenhada neste celular; nada é gravado. A barba é um sombreado aproximado, não uma imagem realista.';

  @override
  String get featureProgressSnapshots => 'Fotos de progresso';

  @override
  String get snapFace => 'Rosto';

  @override
  String get snapBodyFront => 'Corpo · frente';

  @override
  String get snapBodySide => 'Corpo · perfil';

  @override
  String get snapTake => 'Tirar foto';

  @override
  String get snapCompare => 'Comparar antes / depois';

  @override
  String get snapEmpty =>
      'Tire a sua primeira foto. Repita regularmente no mesmo lugar e com a mesma luz para ver as mudanças.';

  @override
  String get snapPrivacyShort =>
      'Guardada só neste celular, dentro do banco de dados criptografado. Nunca enviada nem adicionada à galeria.';

  @override
  String get snapLongPressDelete => 'Toque e segure uma foto para excluí-la.';

  @override
  String get snapWeeklyReminder => 'Lembrar-me toda semana (domingo 9:00)';

  @override
  String get snapDeleteAll => 'Excluir todas as fotos';

  @override
  String get snapReminderRoutine => 'Foto de progresso';

  @override
  String get snapReminderItem => 'Tirar uma foto de progresso';

  @override
  String get snapReminderAdded =>
      'Lembrete semanal de foto adicionado às suas rotinas';

  @override
  String get snapConsentTitle => 'Acompanhe mudanças com fotos privadas';

  @override
  String get snapConsentStored =>
      'As fotos só são salvas quando você toca em Salvar, dentro do banco de dados criptografado deste app.';

  @override
  String get snapConsentNeverUploaded =>
      'Elas nunca saem deste celular e não são adicionadas à galeria.';

  @override
  String get snapConsentOptIn =>
      'É opcional; todos os outros recursos funcionam sem fotos.';

  @override
  String get snapConsentDelete =>
      'Pode excluir qualquer foto, ou todas, quando quiser.';

  @override
  String get snapConsentAccept => 'Entendi — ativar fotos';

  @override
  String get snapGhost => 'Mostrar a foto anterior como guia';

  @override
  String get snapGhostHelp =>
      'Alinhe-se com a imagem esmaecida para as fotos serem comparáveis.';

  @override
  String get snapTipFace =>
      'Mesmo lugar e mesma luz sempre; olhe para a câmera com expressão neutra.';

  @override
  String get snapTipBody =>
      'Apoie o celular na altura da cintura, afaste-se para o corpo todo caber e use roupa parecida sempre.';

  @override
  String get snapCapture => 'Capturar (temporizador de 3 s)';

  @override
  String get snapSaveEncrypted => 'Salvar em privado';

  @override
  String get snapSaved => 'Foto salva em privado';

  @override
  String get snapBefore => 'Antes';

  @override
  String get snapAfter => 'Depois';

  @override
  String get snapCompareHelp =>
      'Arraste sobre a imagem para comparar. Escolha quaisquer duas fotos abaixo.';

  @override
  String get colourTitle => 'Cor e estilo';

  @override
  String get colourYourPalette => 'A sua paleta';

  @override
  String get colourDisclaimer =>
      'As paletas são sugestões da teoria das cores, não regras — vista o que gosta.';

  @override
  String get quizVeinQ =>
      'De que cor parecem as veias da parte interna do seu pulso?';

  @override
  String get quizVeinHelp => 'Olhe à luz do dia, sem filtros.';

  @override
  String get quizVeinBlue => 'Azuis ou roxas';

  @override
  String get quizVeinGreen => 'Esverdeadas';

  @override
  String get quizVeinBoth => 'Difícil dizer / ambas';

  @override
  String get quizJewelQ => 'Que joias ficam melhor na sua pele?';

  @override
  String get quizJewelHelp => 'Pense em anéis ou num relógio contra a mão.';

  @override
  String get quizJewelSilver => 'Prata';

  @override
  String get quizJewelGold => 'Ouro';

  @override
  String get quizJewelBoth => 'As duas ficam bem';

  @override
  String get quizSunQ => 'Como a sua pele costuma reagir ao sol?';

  @override
  String get quizSunHelp =>
      'Sem protetor solar, depois de pouco tempo ao ar livre.';

  @override
  String get quizSunBurns => 'Queima ou fica rosada';

  @override
  String get quizSunTans => 'Bronzeia com facilidade';

  @override
  String get quizSunBoth => 'Um pouco dos dois';

  @override
  String get quizDepthQ => 'Qual é mais próximo do tom da sua pele?';

  @override
  String get quizDepthHelp => 'Isto define quanto contraste a sua paleta tem.';

  @override
  String get quizSeePalette => 'Ver a minha paleta';

  @override
  String get quizRetake => 'Refazer o teste de cor';

  @override
  String get undertoneWarm => 'Subtom quente';

  @override
  String get undertoneCool => 'Subtom frio';

  @override
  String get undertoneNeutral => 'Subtom neutro';

  @override
  String get undertoneWarmExplain =>
      'Tons terrosos, dourados e oliva costumam harmonizar com a sua pele.';

  @override
  String get undertoneCoolExplain =>
      'Tons joia, azuis e rosados costumam harmonizar com a sua pele.';

  @override
  String get undertoneNeutralExplain =>
      'A maioria dos tons equilibrados combina com você; evite só cores muito extremas perto do rosto.';

  @override
  String get depthLight => 'Clara';

  @override
  String get depthMedium => 'Média';

  @override
  String get depthDeep => 'Escura';

  @override
  String get paletteBest => 'Melhores cores';

  @override
  String get paletteBestNote =>
      'Use perto do rosto — blusas, camisas, lenços. Toque numa para experimentar.';

  @override
  String get paletteNeutrals => 'Os seus neutros';

  @override
  String get paletteNeutralsNote =>
      'Cores base para calças, casacos e sapatos.';

  @override
  String get paletteSparingly => 'Use com moderação';

  @override
  String get paletteSparinglyNote =>
      'Bem longe do rosto ou em pequenos detalhes.';

  @override
  String get drapeOpen => 'Experimentar cores ao vivo';

  @override
  String get drapeTitle => 'Teste de cor';

  @override
  String get drapeHint => 'Toque nas cores abaixo e compare';

  @override
  String get drapeNote =>
      'O teste de cor mostra como um tom fica junto ao seu rosto. Só prévia ao vivo; nada é gravado. A luz do ambiente afeta como as cores aparecem.';

  @override
  String get stylePrefsTitle => 'Estilos de que gosta';

  @override
  String get prefClassic => 'Clássico';

  @override
  String get prefMinimal => 'Minimalista';

  @override
  String get prefSmartCasual => 'Esporte fino';

  @override
  String get prefStreet => 'Streetwear';

  @override
  String get prefTraditional => 'Tradicional / étnico';

  @override
  String get prefSporty => 'Esportivo';

  @override
  String get wardrobeAdd => 'Adicionar roupa';

  @override
  String get wardrobeEmpty =>
      'Adicione algumas peças que usa com frequência — partes de cima, de baixo e calçados — e receba ideias de looks com as suas próprias roupas.';

  @override
  String get wardrobePrivacy =>
      'As fotos das roupas ficam neste celular, dentro do banco de dados criptografado.';

  @override
  String get outfitIdeas => 'Ideias de looks';

  @override
  String get outfitIdeasTab => 'Ideias';

  @override
  String get outfitSavedTab => 'Salvos';

  @override
  String get outfitNone =>
      'Ainda sem combinações para esta ocasião. Adicione partes de cima, de baixo e calçados, ou marque peças para esta ocasião.';

  @override
  String get outfitPaletteHint =>
      'Dica: faça o teste de cor para ordenar os looks pela sua paleta.';

  @override
  String get outfitSave => 'Salvar look';

  @override
  String get outfitSavedEmpty =>
      'Os looks salvos aparecem aqui, prontos para manhãs corridas.';

  @override
  String get outfitWoreToday => 'Usei hoje';

  @override
  String get garmentName => 'Nome (ex.: camisa oxford branca)';

  @override
  String get garmentPhoto => 'Adicionar foto (opcional)';

  @override
  String get garmentRetakePhoto => 'Refazer foto';

  @override
  String get garmentPhotoTip =>
      'Estenda a peça ou pendure-a com boa luz, preenchendo o enquadramento. A cor é lida do centro.';

  @override
  String get garmentCategory => 'Tipo';

  @override
  String get garmentColour => 'Cor';

  @override
  String get garmentColourFromPhoto => 'Cor (lida da foto — ajuste se preciso)';

  @override
  String get garmentPattern => 'Padrão';

  @override
  String get garmentFormality => 'Formalidade';

  @override
  String get garmentOccasions => 'Ocasiões';

  @override
  String get garmentOccasionsHelp =>
      'Deixe vazio para permitir qualquer ocasião.';

  @override
  String get catTop => 'Parte de cima / camisa';

  @override
  String get catBottom => 'Parte de baixo';

  @override
  String get catOnePiece => 'Vestido / peça única';

  @override
  String get catOuterwear => 'Casaco';

  @override
  String get catFootwear => 'Calçado';

  @override
  String get catEthnicTop => 'Kurta / parte de cima étnica';

  @override
  String get catEthnicBottom => 'Parte de baixo étnica';

  @override
  String get catAccessory => 'Acessório';

  @override
  String get patSolid => 'Liso';

  @override
  String get patStripes => 'Listras';

  @override
  String get patChecks => 'Xadrez';

  @override
  String get patPrint => 'Estampado';

  @override
  String get occCasual => 'Casual';

  @override
  String get occWork => 'Trabalho';

  @override
  String get occFormal => 'Formal';

  @override
  String get occFestive => 'Festa';

  @override
  String get occSport => 'Esporte';

  @override
  String get form1 => 'Muito descontraído';

  @override
  String get form2 => 'Descontraído';

  @override
  String get form3 => 'Arrumado';

  @override
  String get form4 => 'Elegante';

  @override
  String get form5 => 'Formal';

  @override
  String get reasonAllNeutral => 'Só cores neutras — fácil e alinhado.';

  @override
  String get reasonOneAccent => 'Uma cor de destaque sobre neutros.';

  @override
  String get reasonTonal => 'Tons da mesma família.';

  @override
  String get reasonAnalogous => 'Cores vizinhas que se misturam bem.';

  @override
  String get reasonComplementary =>
      'Cores opostas para um contraste confiante.';

  @override
  String get reasonInPalette => 'A cor perto do rosto está na sua paleta.';

  @override
  String get reasonOnePattern => 'Um único padrão, equilibrado com lisos.';

  @override
  String get reasonMatchedFormality => 'Cada peça combina com a ocasião.';

  @override
  String get reasonFavourite => 'Inclui uma peça favorita.';

  @override
  String get reasonNotWorn => 'Nenhuma foi usada esta semana.';

  @override
  String outfitWornCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usado $count vezes',
      one: 'Usado uma vez',
      zero: 'Ainda não usado',
    );
    return '$_temp0';
  }

  @override
  String get journeyTitle => 'A sua jornada';

  @override
  String journeyLevel(int level) {
    return 'Nível $level';
  }

  @override
  String journeyXpToNext(int xp, int level) {
    return '$xp XP para o nível $level';
  }

  @override
  String journeyTodayXp(int xp) {
    return '+$xp XP hoje';
  }

  @override
  String journeyStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência de $count dias',
      one: 'Sequência de 1 dia',
      zero: 'Ainda sem sequência',
    );
    return '$_temp0';
  }

  @override
  String journeyRestDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias de descanso guardados',
      one: '1 dia de descanso guardado',
      zero: 'Sem dias de descanso guardados',
    );
    return '$_temp0';
  }

  @override
  String get journeyRestDaysHelp =>
      'A cada 7 dias ativos você ganha um dia de descanso. Um dia perdido usa um, e a sua sequência continua.';

  @override
  String get journeyStartTimelapse =>
      'Tire uma foto do rosto para começar o seu time-lapse';

  @override
  String get journeyOneSnapshot =>
      'Adicione outra foto na próxima semana para ver a mudança';

  @override
  String journeySnapshotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get journeyFirst => 'Primeira';

  @override
  String get journeyLatest => 'Mais recente';

  @override
  String get journeyPlay => 'Reproduzir time-lapse';

  @override
  String get journeyPause => 'Pausar';

  @override
  String get journeyCompare => 'Comparar lado a lado';

  @override
  String get journeyAlignNote =>
      'As fotos são alinhadas pelos olhos. Uma foto de frente e bem iluminada alinha melhor.';

  @override
  String get journeyTotalXp => 'XP total';

  @override
  String get journeyBestStreak => 'Melhor sequência';

  @override
  String get journeyActiveDays => 'Dias ativos';

  @override
  String get journeyLast4Weeks => 'Últimas 4 semanas';

  @override
  String get journeyTrends => 'Tendências';

  @override
  String get journeyWeight => 'Peso';

  @override
  String get journeyXpPerDay => 'XP por dia';

  @override
  String get journeyBadges => 'Medalhas';

  @override
  String journeyBadgesEarned(int earned, int total) {
    return '$earned de $total conquistadas';
  }

  @override
  String get journeyHowXp => 'Como funciona o XP';

  @override
  String get journeyHowXpBody =>
      'O XP vem do que você já registra — água, refeições, sono, atividade, hábitos, itens do plano, avaliações, fotos e looks. Um dia com 15 XP ou mais conta para a sua sequência. Perder um dia nunca tira XP.';

  @override
  String get questsTitle => 'Missões de hoje';

  @override
  String questsReward(int xp) {
    return '+$xp XP';
  }

  @override
  String questsAllDone(int xp) {
    return 'Tudo feito — +$xp XP bônus';
  }

  @override
  String questsAllBonus(int xp) {
    return 'Conclua as três para +$xp XP bônus';
  }

  @override
  String get questDrinkTarget => 'Atinja a sua meta de água';

  @override
  String get questLogMeals => 'Registre duas refeições';

  @override
  String get questPostureCheck => 'Faça uma avaliação de postura';

  @override
  String get questCompletePlan => 'Conclua três itens do plano';

  @override
  String get questAllHabits => 'Conclua os hábitos de hoje';

  @override
  String get questLogSleep => 'Registre o sono da noite passada';

  @override
  String get questWorkout => 'Registre um treino ou atividade';

  @override
  String get questWearOutfit => 'Use um look salvo';

  @override
  String get questSnapshot => 'Tire a foto do rosto desta semana';

  @override
  String get questLogWeight => 'Registre o seu peso';

  @override
  String get badgeUnlocked => 'Medalha desbloqueada';

  @override
  String badgesUnlocked(int count) {
    return '$count medalhas desbloqueadas';
  }

  @override
  String get badgeContinue => 'Continuar';

  @override
  String badgeProgress(int progress, int target) {
    return '$progress / $target';
  }

  @override
  String get badgeFirstSteps => 'Primeiros passos';

  @override
  String get badgeFirstStepsInfo => 'Registre algo pela primeira vez.';

  @override
  String get badgeStreak7 => 'Uma semana firme';

  @override
  String get badgeStreak7Info => 'Alcance uma sequência de 7 dias.';

  @override
  String get badgeStreak30 => 'Trinta seguidos';

  @override
  String get badgeStreak30Info => 'Alcance uma sequência de 30 dias.';

  @override
  String get badgeHydration => 'Bem hidratado';

  @override
  String get badgeHydrationInfo => 'Cumpra a meta de água em 7 dias.';

  @override
  String get badgePosture => 'Postura em dia';

  @override
  String get badgePostureInfo => 'Conclua 5 avaliações de postura.';

  @override
  String get badgeFace => 'Explorador do rosto';

  @override
  String get badgeFaceInfo => 'Conclua uma análise facial.';

  @override
  String get badgeJourney => 'Guardião da jornada';

  @override
  String get badgeJourneyInfo => 'Salve 4 fotos de progresso.';

  @override
  String get badgePlanner => 'Planejador';

  @override
  String get badgePlannerInfo => 'Conclua 20 itens do plano.';

  @override
  String get badgeHabits => 'Construtor de hábitos';

  @override
  String get badgeHabitsInfo => 'Conclua hábitos 30 vezes.';

  @override
  String get badgeStylist => 'Estilista';

  @override
  String get badgeStylistInfo => 'Salve 5 looks.';

  @override
  String get badgeLevel5 => 'Nível 5';

  @override
  String get badgeLevel5Info => 'Alcance o nível 5.';

  @override
  String get badgeLevel10 => 'Nível 10';

  @override
  String get badgeLevel10Info => 'Alcance o nível 10.';

  @override
  String get forYouTitle => 'Para você hoje';

  @override
  String get forYouSnapshot => 'Foto semanal';

  @override
  String get forYouSnapshotInfo => 'Adicione uma imagem ao seu time-lapse';

  @override
  String get forYouTryOn => 'Experimente um visual novo';

  @override
  String get forYouTryOnInfo => 'Óculos e barbas, ao vivo em você';

  @override
  String get forYouPosture => 'Avaliação de postura';

  @override
  String get forYouPostureInfo => 'Dois minutos, dicas para você';

  @override
  String get forYouColours => 'Descubra as suas cores';

  @override
  String get forYouColoursInfo => 'Um teste rápido para a sua paleta';

  @override
  String get forYouOutfit => 'Look de hoje';

  @override
  String get forYouOutfitInfo => 'Ideias do seu guarda-roupa';

  @override
  String get forYouFace => 'Formato do rosto';

  @override
  String get forYouFaceInfo => 'Estilos que combinam com você';

  @override
  String get forYouExercise => 'Mexa-se um pouco';

  @override
  String get forYouExerciseInfo => 'Repetições guiadas, contadas ao vivo';

  @override
  String get forYouHairstyles => 'Ideias de penteado';

  @override
  String get forYouHairstylesInfo => 'Escolhidas para o formato do seu rosto';

  @override
  String get goalFinderTitle => 'Encontre o seu foco';

  @override
  String get goalFinderStep1 => 'No que gostaria de trabalhar?';

  @override
  String get goalFinderStep1Hint =>
      'Toque em todas as imagens que lhe dizem algo.';

  @override
  String get goalFinderStep2 => 'Quais visuais têm a ver com você?';

  @override
  String get goalFinderStep2Hint =>
      'Escolha quantos quiser — isto orienta as suas ideias de looks.';

  @override
  String get goalFinderNext => 'Próximo';

  @override
  String get goalFinderBack => 'Voltar';

  @override
  String get goalFinderSave => 'Salvar o meu foco';

  @override
  String get goalFinderSaved =>
      'O seu foco foi salvo. Missões e sugestões agora o seguem.';

  @override
  String goalFinderSelected(int count) {
    return '$count selecionados';
  }

  @override
  String get forYouGoals => 'O que você quer?';

  @override
  String get forYouGoalsInfo => 'Escolha imagens que o inspirem';

  @override
  String get profileGender => 'Gênero';

  @override
  String get profileGenderHelp =>
      'Usado só para estimar calorias e mostrar exemplos de estilo relevantes.';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Feminino';

  @override
  String get genderNonBinary => 'Não binário';

  @override
  String get genderPreferNot => 'Prefiro não dizer';

  @override
  String get profileDiet => 'Preferência alimentar';

  @override
  String get dietVegetarian => 'Vegetariana';

  @override
  String get dietEggetarian => 'Ovovegetariana';

  @override
  String get dietNonVegetarian => 'Não vegetariana';

  @override
  String get dietVegan => 'Vegana';

  @override
  String get profileStyleFit => 'Mostrar exemplos de estilo para';

  @override
  String get styleFitAuto => 'Conforme o meu gênero';

  @override
  String get styleFitMenswear => 'Moda masculina';

  @override
  String get styleFitWomenswear => 'Moda feminina';

  @override
  String get styleFitAll => 'Todos';

  @override
  String get onboardingAboutTitle => 'Sobre você';

  @override
  String get onboardingAboutBody =>
      'Tudo aqui é opcional e fica neste celular. Personaliza os seus planos, missões e sugestões de estilo.';

  @override
  String get onboardingHeightCm => 'Altura (cm)';

  @override
  String get onboardingHeightFt => 'Altura (ft)';

  @override
  String get onboardingHeightIn => 'in';

  @override
  String get onboardingWeightKg => 'Peso (kg)';

  @override
  String get onboardingWeightLb => 'Peso (lb)';

  @override
  String get onboardingInvalid => 'Verifique este valor';

  @override
  String get greetingMorning => 'Bom dia';

  @override
  String get greetingAfternoon => 'Boa tarde';

  @override
  String get greetingEvening => 'Boa noite';

  @override
  String greetingNamed(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeCompleteProfile => 'Personalize o seu app';

  @override
  String get homeCompleteProfileInfo =>
      'Adicione gênero, altura e peso para planos precisos e estilos relevantes.';

  @override
  String get forYouBodyPlan => 'O seu plano de dieta';

  @override
  String get forYouBodyPlanInfo => 'Refeições e treino para o seu objetivo';

  @override
  String get featureBodyPlan => 'Plano de dieta e corpo';

  @override
  String get bodyPlanIntro =>
      'Metas de calorias e proteína, refeições diárias e uma semana de treino simples, com base na sua altura, peso e objetivo.';

  @override
  String get bodyPlanNeedData =>
      'Adicione a sua altura e peso para criar um plano.';

  @override
  String get bodyPlanImprove =>
      'Adicione gênero, faixa etária e nível de atividade no Perfil para uma estimativa melhor.';

  @override
  String get bodyPlanOpenProfile => 'Abrir perfil';

  @override
  String get bodyPlanGoal => 'O seu objetivo';

  @override
  String get planLoseFat => 'Perder gordura';

  @override
  String get planMaintain => 'Manter a forma';

  @override
  String get planGainWeight => 'Ganhar peso';

  @override
  String get planBuildMuscle => 'Ganhar músculo';

  @override
  String get planLoseFatInfo =>
      'Um déficit calórico moderado com muita proteína';

  @override
  String get planMaintainInfo =>
      'Coma no nível de manutenção e treine com regularidade';

  @override
  String get planGainWeightInfo =>
      'Um superávit constante para ganhar peso saudável';

  @override
  String get planBuildMuscleInfo => 'Um superávit leve com treino de força';

  @override
  String get planBlockUnderage =>
      'Menores de 18: planeje mudanças de peso com um médico. Há orientações de manutenção disponíveis.';

  @override
  String get planBlockUnderweight =>
      'O seu IMC está abaixo de 18,5, por isso perder gordura não é sugerido.';

  @override
  String get planBlockHeavy =>
      'O seu IMC é 25 ou mais. Experimente Ganhar músculo.';

  @override
  String get bodyPlanPace => 'Ritmo';

  @override
  String get paceGentle => 'Suave';

  @override
  String get paceSteady => 'Constante';

  @override
  String get paceBrisk => 'Rápido';

  @override
  String bodyPlanRate(String rate) {
    return 'Cerca de $rate por semana';
  }

  @override
  String get bodyPlanTarget => 'Peso-alvo (opcional)';

  @override
  String bodyPlanHealthyRange(String range) {
    return 'Faixa saudável para a sua altura: $range';
  }

  @override
  String get bodyPlanCalories => 'Calorias';

  @override
  String get bodyPlanProtein => 'Proteína';

  @override
  String get bodyPlanCarbs => 'Carboidratos';

  @override
  String get bodyPlanFat => 'Gordura';

  @override
  String get bodyPlanWater => 'Água';

  @override
  String bodyPlanKcal(int value) {
    return '$value kcal';
  }

  @override
  String bodyPlanGrams(int value) {
    return '$value g';
  }

  @override
  String bodyPlanMaintenance(int kcal) {
    return 'A manutenção é de cerca de $kcal kcal por dia';
  }

  @override
  String bodyPlanTimeline(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'Cerca de $weeks semanas até a sua meta',
      one: 'Cerca de 1 semana até a sua meta',
    );
    return '$_temp0';
  }

  @override
  String get bodyPlanFloorNote =>
      'Mantido num mínimo seguro, por isso o progresso será mais lento que este ritmo.';

  @override
  String get bodyPlanStart => 'Começar o meu plano';

  @override
  String get bodyPlanStarted => 'O seu plano começou';

  @override
  String get bodyPlanDisclaimer =>
      'Estimativas para adultos saudáveis, não aconselhamento médico. Se tem alguma condição de saúde, está grávida ou toma medicação, fale antes com um médico.';

  @override
  String bodyPlanSince(String date) {
    return 'Desde $date';
  }

  @override
  String get bodyPlanToday => 'Metas de hoje';

  @override
  String bodyPlanEaten(int eaten, int target) {
    return '$eaten de $target kcal registradas hoje';
  }

  @override
  String get bodyPlanMenu => 'Cardápio de hoje';

  @override
  String bodyPlanServings(String servings) {
    return '× $servings';
  }

  @override
  String get bodyPlanProteinBoost => 'Reforço de proteína';

  @override
  String get bodyPlanLog => 'Registrar';

  @override
  String get bodyPlanLogged => 'Registrado';

  @override
  String get bodyPlanSwap => 'Trocar';

  @override
  String get bodyPlanWeek => 'Treino desta semana';

  @override
  String get workoutStrengthA => 'Força A';

  @override
  String get workoutStrengthB => 'Força B';

  @override
  String get workoutCardio => 'Cardio';

  @override
  String get workoutMobility => 'Mobilidade';

  @override
  String get workoutRest => 'Descanso';

  @override
  String bodyPlanMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bodyPlanTodayWorkout(String workout) {
    return 'Hoje: $workout';
  }

  @override
  String get bodyPlanAddRoutine => 'Adicionar treinos às minhas rotinas';

  @override
  String get bodyPlanRoutineAdded => 'Adicionado às suas rotinas';

  @override
  String get bodyPlanRoutineName => 'Plano de treino';

  @override
  String get bodyPlanWorkoutItem => 'Treino';

  @override
  String get bodyPlanProgress => 'Progresso';

  @override
  String bodyPlanWeightNow(String now, String start) {
    return '$now agora · começou com $start';
  }

  @override
  String bodyPlanExpected(String weight) {
    return 'Esperado até agora: $weight';
  }

  @override
  String get bodyPlanUpdate => 'O seu peso mudou. Atualizar as suas metas?';

  @override
  String get bodyPlanUpdateAction => 'Atualizar';

  @override
  String get bodyPlanEnd => 'Encerrar plano';

  @override
  String get bodyPlanEndConfirm =>
      'Encerrar este plano? As refeições e treinos registrados ficam guardados.';

  @override
  String get bodyPlanLogWeight => 'Registrar peso';

  @override
  String get bodyPlanChange => 'Mudar plano';

  @override
  String get profileRegion => 'Onde você mora?';

  @override
  String get profileRegionHelp =>
      'Usado para sugerir comida local, exercício adequado e dicas para o clima.';

  @override
  String get regionIndiaNorth => 'Norte da Índia';

  @override
  String get regionIndiaSouth => 'Sul da Índia';

  @override
  String get regionIndiaEast => 'Leste da Índia';

  @override
  String get regionIndiaWest => 'Oeste da Índia';

  @override
  String get regionSouthAsia => 'Resto do Sul da Ásia';

  @override
  String get regionEastAsia => 'Ásia Oriental';

  @override
  String get regionSoutheastAsia => 'Sudeste Asiático';

  @override
  String get regionMiddleEast => 'Oriente Médio';

  @override
  String get regionAfrica => 'África';

  @override
  String get regionEurope => 'Europa';

  @override
  String get regionNorthAmerica => 'América do Norte';

  @override
  String get regionLatinAmerica => 'América Latina';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get bodyPlanHotClimate =>
      'Clima quente: treine de manhã ou à noite, quando está mais fresco, e beba água ao longo do dia.';

  @override
  String bodyPlanLocalMenu(String region) {
    return 'Refeições da culinária de $region sempre que possível.';
  }

  @override
  String get dailyPlan => 'Plano diário';

  @override
  String get partMorning => 'Manhã';

  @override
  String get partAfternoon => 'Tarde';

  @override
  String get partEvening => 'Noite';

  @override
  String get partAnytime => 'Qualquer hora';

  @override
  String agendaWater(String target) {
    return 'Beber $target';
  }

  @override
  String agendaWorkout(String workout, int minutes) {
    return '$workout · $minutes min';
  }

  @override
  String agendaOptional(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opcionais hoje',
      one: '1 opcional hoje',
    );
    return '$_temp0';
  }

  @override
  String get agendaMissed => 'Perdido';

  @override
  String get agendaReschedule => 'Reagendar';

  @override
  String get agendaSkip => 'Pular hoje';

  @override
  String get agendaDone => 'Marcar como feito';

  @override
  String get agendaUndo => 'Desfazer';

  @override
  String agendaLookingBack(String date) {
    return 'Revendo $date';
  }

  @override
  String get agendaEmpty =>
      'Nada planejado ainda. Adicione uma rotina, hábitos ou um plano de dieta para montar o seu dia.';

  @override
  String agendaProgress(int done, int total) {
    return '$done de $total feitos';
  }

  @override
  String get dayModeTitle => 'Como está o dia?';

  @override
  String get dayModeNormal => 'Normal';

  @override
  String get dayModeBusy => 'Corrido';

  @override
  String get dayModeLow => 'Pouca energia';

  @override
  String get dayModeNormalInfo => 'O seu plano completo.';

  @override
  String get dayModeBusyInfo => 'Só o essencial, com um treino de 5 minutos.';

  @override
  String get dayModeLowInfo =>
      'Mobilidade leve em vez de treino. Descansar também conta.';

  @override
  String get moodTitle => 'Como você está';

  @override
  String get moodQuestion => 'Como se sente?';

  @override
  String get energyQuestion => 'Nível de energia';

  @override
  String get mood1 => 'Mal';

  @override
  String get mood2 => 'Mais ou menos';

  @override
  String get mood3 => 'Ok';

  @override
  String get mood4 => 'Bem';

  @override
  String get mood5 => 'Ótimo';

  @override
  String get energy1 => 'Esgotado';

  @override
  String get energy2 => 'Baixa';

  @override
  String get energy3 => 'Estável';

  @override
  String get energy4 => 'Boa';

  @override
  String get energy5 => 'Alta';

  @override
  String get moodSave => 'Salvar';

  @override
  String get moodSaved => 'Obrigado por contar';

  @override
  String get moodSuggestLow =>
      'A energia está baixa hoje. Fazer de hoje um dia tranquilo?';

  @override
  String get moodSwitch => 'Mudar';

  @override
  String moodToday(String mood, String energy) {
    return 'Hoje: $mood · energia $energy';
  }

  @override
  String get fiveTitle => 'Tem 5 minutos?';

  @override
  String get fiveWater => 'Beba um copo de água';

  @override
  String get fiveWaterInfo =>
      'Você está um pouco atrasado na água para esta hora do dia.';

  @override
  String fiveHabit(String habit) {
    return 'Faça agora: $habit';
  }

  @override
  String get fiveHabitInfo => 'Um hábito, concluído em poucos minutos.';

  @override
  String get fiveMobility => 'Mobilidade de 5 minutos';

  @override
  String get fiveMobilityInfo => 'Pescoço, ombros e postura: uma pausa rápida.';

  @override
  String get fiveOutfit => 'Planeje o look de amanhã';

  @override
  String get fiveOutfitInfo => 'Escolha hoje à noite e decida menos amanhã.';

  @override
  String get fivePosture => 'Avaliação rápida de postura';

  @override
  String get fivePostureInfo => 'Dois minutos com a câmera, dicas para você.';

  @override
  String get fiveDo => 'Fazer';

  @override
  String get quickAdd => 'Adicionar rápido';

  @override
  String quickWater(int ml) {
    return '+$ml ml de água';
  }

  @override
  String get quickMeal => 'Registrar refeição';

  @override
  String get quickWeight => 'Registrar peso';

  @override
  String get quickSleep => 'Registrar sono';

  @override
  String get quickMood => 'Humor';

  @override
  String get quickAdded => 'Adicionado';

  @override
  String get remindersQuiet => 'Horário silencioso';

  @override
  String remindersQuietInfo(String start, String end) {
    return 'Sem lembretes das $start às $end. Os itens continuam no seu plano.';
  }

  @override
  String get remindersQuietOff =>
      'Desativado: os lembretes podem chegar a qualquer hora.';

  @override
  String get insightsTitle => 'Análises';

  @override
  String get insightsIntro =>
      'Plano versus o que realmente aconteceu. Dias sem registros aparecem como sem dados, nunca como falhas.';

  @override
  String get insightsHomeInfo =>
      'Plano versus realidade, pontuação de sono e tendências';

  @override
  String get rangeWeek => 'Semana';

  @override
  String get rangeMonth => 'Mês';

  @override
  String get metricPlan => 'Itens do plano';

  @override
  String get metricHabits => 'Hábitos';

  @override
  String get metricWater => 'Água';

  @override
  String get metricSleep => 'Sono';

  @override
  String get metricActivity => 'Minutos ativos';

  @override
  String get metricMeals => 'Refeições registradas';

  @override
  String get metricMood => 'Humor';

  @override
  String insightsMet(int met, int logged) {
    return 'Cumprido em $met de $logged dias registrados';
  }

  @override
  String insightsLogged(int logged) {
    return 'Registrado em $logged dias';
  }

  @override
  String get insightsNoData => 'Ainda sem registros neste período.';

  @override
  String insightsAverage(String value) {
    return 'Média $value';
  }

  @override
  String insightsUp(String value, String period) {
    return '$value a mais que o(a) $period anterior';
  }

  @override
  String insightsDown(String value, String period) {
    return '$value a menos que o(a) $period anterior';
  }

  @override
  String insightsSame(String period) {
    return 'Igual ao(à) $period anterior';
  }

  @override
  String get insightsPeriodWeek => 'semana';

  @override
  String get insightsPeriodMonth => 'mês';

  @override
  String get legendMet => 'Cumprido';

  @override
  String get legendPartial => 'Em parte';

  @override
  String get legendMissed => 'Não cumprido';

  @override
  String get legendNoData => 'Sem dados';

  @override
  String get sleepScoreTitle => 'Pontuação de sono';

  @override
  String get sleepScoreInfo =>
      'Com base nos horários de deitar e acordar das últimas 7 noites: duração (70 pontos) e regularidade (30). Sem fases do sono; isso exige um wearable.';

  @override
  String sleepAverage(String value) {
    return '$value por noite em média';
  }

  @override
  String sleepSpread(int minutes) {
    return 'A hora de deitar varia cerca de $minutes min';
  }

  @override
  String sleepNights(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count noites registradas',
      one: '1 noite registrada',
    );
    return '$_temp0';
  }

  @override
  String get sleepExcellent => 'Excelente';

  @override
  String get sleepGood => 'Boa';

  @override
  String get sleepFair => 'Razoável';

  @override
  String get sleepCare => 'Precisa de atenção';

  @override
  String get sleepScoreEmpty =>
      'Registre algumas noites de sono para ver a sua pontuação.';

  @override
  String get evolutionTitle => 'Evolução';

  @override
  String get evolutionIntro =>
      'Momentos do seu caminho, a partir do que você fez. Adicione também as suas notas.';

  @override
  String get evolutionEmpty =>
      'Os seus marcos aparecerão aqui à medida que usar o app.';

  @override
  String get evolutionAddNote => 'Adicionar nota';

  @override
  String get evolutionNoteHint => 'O que mudou, como se sente…';

  @override
  String get evolutionSeeAll => 'Ver tudo';

  @override
  String get msFirstStep => 'Primeiro passo: você registrou algo';

  @override
  String get msFirstPosture => 'Primeira avaliação de postura';

  @override
  String get msFirstFace => 'Primeira análise facial';

  @override
  String get msFirstSnapshot => 'Primeira foto de progresso';

  @override
  String get msFirstOutfit => 'Primeiro look salvo';

  @override
  String msPlanStarted(String plan) {
    return 'Começou um plano: $plan';
  }

  @override
  String get msStreak7 => 'Alcançou uma sequência de 7 dias';

  @override
  String get msStreak30 => 'Alcançou uma sequência de 30 dias';

  @override
  String get msHabits30 => '30 hábitos concluídos';

  @override
  String msWeightDown(String value) {
    return '$value a menos desde a primeira pesagem';
  }

  @override
  String msWeightUp(String value) {
    return '$value a mais desde a primeira pesagem';
  }

  @override
  String get reviewTitle => 'A sua semana';

  @override
  String reviewWeekOf(String date) {
    return 'Semana de $date';
  }

  @override
  String reviewActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias ativos',
      one: '1 dia ativo',
    );
    return '$_temp0';
  }

  @override
  String reviewWater(int met) {
    return 'Meta de água cumprida em $met dias';
  }

  @override
  String reviewSleep(String value) {
    return 'Sono médio $value';
  }

  @override
  String reviewActivity(int count) {
    return 'Ativo em $count dias';
  }

  @override
  String reviewBest(String day) {
    return 'Melhor dia: $day';
  }

  @override
  String get reviewTipPlan =>
      'Próxima semana: mude os itens do plano para horários que combinem melhor com o seu dia.';

  @override
  String get reviewTipHabits =>
      'Próxima semana: hábitos pequenos. Um que você nunca falha vale mais que três que pula.';

  @override
  String get reviewTipWater =>
      'Próxima semana: deixe uma garrafa à vista e beba um copo a cada refeição.';

  @override
  String get reviewTipSleep =>
      'Próxima semana: tente deitar sempre à mesma hora, mesmo no fim de semana.';

  @override
  String get reviewTipActivity =>
      'Próxima semana: uma caminhada de 10 minutos depois de comer conta.';

  @override
  String get reviewTipMeals =>
      'Próxima semana: registrar refeições ajuda o plano a se ajustar a você.';

  @override
  String get reviewTipKeep => 'Próxima semana: mantenha o ritmo que criou.';

  @override
  String get reviewClose => 'Fechar';

  @override
  String get reviewSeeInsights => 'Ver análises';

  @override
  String get postureCompare => 'Comparar';

  @override
  String get postureCompareTitle => 'Comparar sessões';

  @override
  String get postureCompareSetup =>
      'Para uma comparação justa use a mesma configuração: mesmo lugar e distância, luz parecida, roupa justa e um horário semelhante.';

  @override
  String get postureCompareEarlier => 'Antes';

  @override
  String get postureCompareLater => 'Depois';

  @override
  String get postureCompareChange => 'Mudança';

  @override
  String get postureCompareNeedTwo =>
      'Salve duas avaliações com a mesma vista para compará-las.';

  @override
  String get connectedTitle => 'Dados conectados';

  @override
  String get connectedIntro =>
      'Acompanhe passos, caminhadas, corridas e sono com os sensores deste celular. Tudo fica neste aparelho: sem conta, sem nuvem, nada enviado.';

  @override
  String get connectedPhoneSensors => 'Sensores deste celular';

  @override
  String get connectedSteps => 'Passos';

  @override
  String get connectedStepsInfo =>
      'Contados pelo sensor de passos do celular, verificados a cada 15 minutos.';

  @override
  String get connectedActivity => 'Caminhadas, corridas e pedaladas';

  @override
  String get connectedActivityInfo =>
      'Detectadas no celular quando você se move por 10 minutos ou mais.';

  @override
  String get connectedSleep => 'Horários de deitar e acordar';

  @override
  String get connectedSleepInfo =>
      'Estimados pelo celular durante a noite. Pode editar ou excluir qualquer noite.';

  @override
  String get connectedNoSensor => 'Este celular não tem sensor de passos.';

  @override
  String get connectedNoPlay =>
      'A detecção de caminhadas e sono precisa do Google Play Services neste celular.';

  @override
  String get connectedPermission =>
      'Permita \"Atividade física\" para o celular contar passos e movimento.';

  @override
  String get connectedAllow => 'Permitir';

  @override
  String get connectedHealthConnect => 'Health Connect';

  @override
  String get connectedHcInfo =>
      'O repositório de saúde do Android está neste celular. Leia passos, treinos, sono, peso, altura e água que outros apps guardaram lá, sem conta.';

  @override
  String get connectedHcAbsent =>
      'O Health Connect não está neste celular. Tudo bem: os sensores do próprio celular cobrem passos, caminhadas e sono.';

  @override
  String get connectedHcConnect => 'Escolher o que ler';

  @override
  String get connectedSyncNow => 'Sincronizar agora';

  @override
  String connectedLastSync(String time) {
    return 'Última sincronização $time';
  }

  @override
  String get connectedNeverSynced => 'Ainda não sincronizado';

  @override
  String connectedSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens atualizados',
      one: '1 item atualizado',
      zero: 'Atualizado',
    );
    return '$_temp0';
  }

  @override
  String get connectedRemove => 'Remover dados importados';

  @override
  String get connectedRemoveConfirm =>
      'Remover tudo o que foi importado desta fonte? Os seus próprios registros ficam.';

  @override
  String connectedRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens removidos',
      one: '1 item removido',
    );
    return '$_temp0';
  }

  @override
  String get connectedPrivacy =>
      'Só leitura e neste aparelho. Passos de várias fontes nunca somam duas vezes: usa-se o maior total diário.';

  @override
  String get sourcePhone => 'Sensor do celular';

  @override
  String get backupTitle => 'Backup e exportação';

  @override
  String get backupSubtitle =>
      'Mude de celular, guarde uma cópia segura ou abra os seus dados noutro lugar';

  @override
  String get backupIntro =>
      'Não há conta nem nuvem, então os seus dados só existem neste celular. Faça um arquivo de backup e guarde-o em local seguro, ou envie-o para o seu outro celular.';

  @override
  String get backupEncrypted => 'Backup criptografado';

  @override
  String get backupEncryptedInfo =>
      'Tudo do app, protegido com uma frase-senha que você escolhe. Restaure em qualquer celular com o Personality.';

  @override
  String get backupIncludePhotos => 'Incluir fotos de progresso';

  @override
  String get backupIncludePhotosInfo => 'Deixa o arquivo maior.';

  @override
  String get backupSaveFile => 'Salvar em arquivo';

  @override
  String get backupShare => 'Enviar';

  @override
  String get backupNever => 'Ainda não foi feito nenhum backup neste celular';

  @override
  String backupLast(String time) {
    return 'Último backup $time';
  }

  @override
  String get backupSaved => 'Salvo';

  @override
  String get backupFailed => 'Não funcionou. Tente de novo.';

  @override
  String get backupRestoreTitle => 'Restaurar um backup';

  @override
  String get backupRestoreInfo =>
      'Abra um arquivo .personality do seu outro celular, de um drive ou de uma conversa.';

  @override
  String get backupChooseFile => 'Escolher arquivo de backup';

  @override
  String get backupExportTitle => 'Exportar para outros apps';

  @override
  String get backupExportInfo =>
      'Cópias legíveis para abrir numa planilha ou noutro app. Sem criptografia e sem fotos.';

  @override
  String get backupCsv => 'Planilha (CSV)';

  @override
  String get backupCsvInfo => 'Um zip com uma tabela por tipo de registro';

  @override
  String get backupJson => 'JSON';

  @override
  String get backupJsonInfo => 'Tudo num arquivo, para desenvolvedores';

  @override
  String get backupPrivacy =>
      'Os arquivos só vão para onde você os enviar. Sem a frase-senha ninguém consegue ler um backup, nem nós, e uma frase-senha perdida não pode ser recuperada.';

  @override
  String get backupPassphrase => 'Frase-senha';

  @override
  String get backupPassphraseAgain => 'Repita a frase-senha';

  @override
  String get backupPassphraseCreate => 'Escolha uma frase-senha';

  @override
  String get backupPassphraseEnter => 'Digite a frase-senha do backup';

  @override
  String get backupPassphraseWarning =>
      'Você vai precisar dela para restaurar. Anote: não pode ser redefinida.';

  @override
  String get backupPassphraseShort => 'Use pelo menos 8 caracteres';

  @override
  String get backupPassphraseMismatch => 'As frases-senha não coincidem';

  @override
  String get backupShowPassphrase => 'Mostrar frase-senha';

  @override
  String get backupContinue => 'Continuar';

  @override
  String backupFound(String date, int records, int photos) {
    return 'Backup de $date: $records registros, $photos fotos.';
  }

  @override
  String get backupMergeInfo =>
      'Adicionar: mantém o que está neste celular e acrescenta o que faltar.';

  @override
  String get backupReplaceInfo =>
      'Substituir: os dados deste celular são trocados pelos do backup.';

  @override
  String get backupMerge => 'Adicionar';

  @override
  String get backupReplace => 'Substituir';

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros restaurados',
      one: '1 registro restaurado',
    );
    return '$_temp0';
  }

  @override
  String get backupErrorNotBackup =>
      'Este não é um arquivo de backup do Personality.';

  @override
  String get backupErrorDamaged =>
      'O arquivo de backup está danificado ou incompleto.';

  @override
  String get backupErrorPassphrase => 'Frase-senha incorreta.';

  @override
  String get backupErrorTooNew =>
      'Este backup é de uma versão mais nova. Atualize o app e tente de novo.';

  @override
  String get exMartialArts => 'Artes marciais';

  @override
  String get exFace => 'Rosto e mandíbula';

  @override
  String get actionDone => 'Concluído';

  @override
  String get levelBeginner => 'Iniciante';

  @override
  String get levelIntermediate => 'Intermediário';

  @override
  String get levelAdvanced => 'Avançado';

  @override
  String get exerciseSearch => 'Pesquise exercícios, músculos ou equipamentos';

  @override
  String get filterNoEquipment => 'Sem equipamento';

  @override
  String exerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercícios',
      one: '1 exercício',
    );
    return '$_temp0';
  }

  @override
  String exerciseAlsoWorks(String muscles) {
    return 'Também trabalha: $muscles';
  }

  @override
  String get workoutsTitle => 'Treinos guiados';

  @override
  String get workoutsSubtitle =>
      'Acompanhe com cronômetro e figura em movimento';

  @override
  String get workoutsMore => 'Mais treinos';

  @override
  String workoutMinutes(int count) {
    return '$count min';
  }

  @override
  String workoutRounds(int count) {
    return '$count rodadas';
  }

  @override
  String workoutSeconds(int count) {
    return '$count s';
  }

  @override
  String workoutReps(int count) {
    return '$count rep.';
  }

  @override
  String get workoutEachSide => 'cada lado';

  @override
  String get workoutStart => 'Começar treino';

  @override
  String get workoutGetReady => 'Prepare-se';

  @override
  String workoutRoundOf(int round, int total) {
    return 'Rodada $round de $total';
  }

  @override
  String workoutSide(int side) {
    return 'Lado $side de 2';
  }

  @override
  String workoutUpNext(String name) {
    return 'A seguir: $name';
  }

  @override
  String get workoutPrevious => 'Anterior';

  @override
  String get workoutPause => 'Pausar';

  @override
  String get workoutResume => 'Retomar';

  @override
  String get workoutSkip => 'Pular';

  @override
  String get workoutDone => 'Treino concluído. Muito bem!';

  @override
  String workoutDoneMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos de movimento',
      one: '1 minuto de movimento',
    );
    return '$_temp0';
  }

  @override
  String get contentTitle => 'Pacotes de conteúdo';

  @override
  String get contentSubtitle => 'Baixe mais exercícios, ilustrações e rotinas';

  @override
  String get contentGetMore => 'Mais exercícios';

  @override
  String get contentGetMoreInfo =>
      'Mais de 1.500 exercícios, ilustrações, ioga, artes marciais e rotinas de rosto e mandíbula. Grátis; baixe só o que precisar.';

  @override
  String get contentIntro =>
      'Os pacotes são grátis e opcionais. Baixe só o que precisar; no celular funcionam offline e você pode removê-los quando quiser.';

  @override
  String get contentWifiOnly => 'Baixar só por Wi-Fi';

  @override
  String get contentDownload => 'Baixar';

  @override
  String get contentUpdate => 'Atualizar';

  @override
  String get contentRemove => 'Remover';

  @override
  String get contentOnPhone => 'Neste celular';

  @override
  String get contentInstalled => 'Pacote pronto para usar';

  @override
  String contentRemoveConfirm(String name) {
    return 'Remover \"$name\" deste celular? Você pode baixá-lo de novo depois.';
  }

  @override
  String get contentOffline =>
      'Você está offline. Conecte-se à internet para ver os pacotes.';

  @override
  String get contentWifiNeeded =>
      'Conecte-se a uma rede Wi-Fi ou desative \"Só por Wi-Fi\".';

  @override
  String get contentDamaged =>
      'O download não passou na verificação, por isso não foi usado. Tente de novo.';

  @override
  String get contentFailed => 'Não foi possível baixar agora. Tente de novo.';

  @override
  String get contentRetry => 'Tentar de novo';

  @override
  String get contentPrivacy =>
      'Os pacotes vêm só de github.com/prashantkeshr/personality-content e são verificados antes do uso. Baixar nunca envia nada sobre você, e os seus dados de saúde nunca usam a internet.';

  @override
  String get navGrowth => 'Meu crescimento';

  @override
  String get growthSearchHint => 'Pesquise exercícios, técnicas e dicas';

  @override
  String get growthProgress => 'O seu progresso';

  @override
  String get growthCoachSoon => 'Em breve: um treinador privado no aparelho.';

  @override
  String get profileMenu => 'Você';

  @override
  String get blueprintTitle => 'O seu mapa';

  @override
  String get blueprintIntro =>
      'Cada área por si, sem uma pontuação única. Só o que vai bem e o próximo pequeno passo.';

  @override
  String get blueprintNextStep => 'O seu próximo passo';

  @override
  String get blueprintGo => 'Vamos';

  @override
  String get blueprintFocus => 'O seu foco';

  @override
  String get blueprintExplore => 'Mais áreas';

  @override
  String get blueprintPickGoals =>
      'Escolha os seus objetivos para moldar o seu mapa';

  @override
  String get blueprintNoData => 'Ainda sem registros';

  @override
  String blueprintDaysMet(int count) {
    return '$count de 7 dias';
  }

  @override
  String blueprintPercent(int percent) {
    return '$percent% nesta quinzena';
  }

  @override
  String get areaBody => 'Corpo e peso';

  @override
  String get areaFitness => 'Condicionamento';

  @override
  String get areaPosture => 'Postura';

  @override
  String get areaSleep => 'Sono';

  @override
  String get areaHydration => 'Hidratação';

  @override
  String get areaHabits => 'Hábitos';

  @override
  String get areaStyle => 'Estilo';

  @override
  String get areaGrooming => 'Cuidados pessoais';

  @override
  String get areaSkills => 'Habilidades e artes marciais';

  @override
  String get actSetBodyPlan => 'Configure o seu plano corporal';

  @override
  String get actLogWeight => 'Registre o seu peso';

  @override
  String get actStartWorkout => 'Comece um treino guiado';

  @override
  String get actCheckPosture => 'Avalie a sua postura';

  @override
  String get actLogSleep => 'Registre o sono da noite passada';

  @override
  String get actAddWater => 'Beba um copo de água';

  @override
  String get actDoHabits => 'Marque os hábitos de hoje';

  @override
  String get actAddClothes => 'Adicione roupas ao guarda-roupa';

  @override
  String get actBuildOutfit => 'Monte um look';

  @override
  String get actTakeSnapshot => 'Tire a foto desta semana';

  @override
  String get actPractiseSkill => 'Pratique uma arte marcial';

  @override
  String get whyTitle => 'Por que estou vendo isto?';

  @override
  String get whyBenefit => 'Em que ajuda';

  @override
  String get whyAlternatives => 'Outras opções';

  @override
  String get whyYourGoal =>
      'Você escolheu isto como um dos seus objetivos e ainda não há nada registrado. Um pequeno começo basta.';

  @override
  String get whyNoRecords =>
      'Ainda não há nada registrado aqui, então é um bom lugar para começar se lhe interessar.';

  @override
  String get whyOnTrack =>
      'Você está no caminho certo esta semana. Mantenha o ritmo.';

  @override
  String get whyPartly => 'Você já fez parte do caminho esta semana.';

  @override
  String get whyBehind =>
      'Esta área recebeu menos atenção ultimamente. Um pequeno passo a recupera.';

  @override
  String get benefitBody =>
      'Pesar-se com regularidade mostra a tendência real, e os altos e baixos diários deixam de preocupar.';

  @override
  String get benefitFitness =>
      'Mexer-se quase todos os dias melhora a energia, o humor e o sono.';

  @override
  String get benefitPosture =>
      'Uma avaliação de vez em quando evita que a tensão no pescoço e nas costas se acumule.';

  @override
  String get benefitSleep =>
      'Sono regular ajuda a concentração, o apetite e a recuperação.';

  @override
  String get benefitHydration =>
      'Água suficiente ajuda a energia, a pele e a concentração.';

  @override
  String get benefitHabits =>
      'Pequenos hábitos diários somam as maiores mudanças.';

  @override
  String get benefitStyle =>
      'Saber o que tem torna o arrumar-se mais rápido e mais confiante.';

  @override
  String get benefitGrooming =>
      'Uma foto semanal mostra como as rotinas mudam as coisas com o tempo.';

  @override
  String get benefitSkills =>
      'As artes marciais desenvolvem ao mesmo tempo condicionamento, equilíbrio, foco e confiança.';

  @override
  String get altBody =>
      'Acompanhe medidas em vez do peso, ou siga o seu plano de dieta e corpo.';

  @override
  String get altFitness =>
      'Uma caminhada rápida, uma rotina de ioga ou um exercício de artes marciais contam.';

  @override
  String get altPosture =>
      'Faça o treino Pausa da mesa, ou defina um lembrete de postura.';

  @override
  String get altSleep =>
      'Experimente o treino Desacelerar, ou defina um lembrete para deitar.';

  @override
  String get altHydration =>
      'Defina lembretes de água, ou tenha uma garrafa por perto.';

  @override
  String get altHabits =>
      'Comece com um hábito minúsculo, ou use uma rotina pronta.';

  @override
  String get altStyle =>
      'Descubra as suas cores, ou veja visuais que combinam com você.';

  @override
  String get altGrooming =>
      'Veja o formato do seu rosto para ideias de penteado.';

  @override
  String get altSkills =>
      'Comece com os balanços de perna do Kalaripayattu, o dand-baithak do Kushti ou o básico do boxe.';

  @override
  String get skillsTitle => 'Habilidades e artes marciais';

  @override
  String get skillsIntro =>
      'Artes marciais indianas e do mundo, cada uma com as suas técnicas, exercícios e dicas.';

  @override
  String get skillsIndian => 'Artes marciais indianas';

  @override
  String get skillsWorld => 'Artes marciais do mundo';

  @override
  String get skillsSeeAll => 'Ver tudo';

  @override
  String skillsTechniques(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count técnicas',
      one: '1 técnica',
    );
    return '$_temp0';
  }

  @override
  String get skillsTechniquesTitle => 'Técnicas e exercícios';

  @override
  String get skillsGetPackShort => 'Dicas · técnicas para baixar';

  @override
  String get skillsGetPack => 'Baixar as técnicas';

  @override
  String get skillsGetPackInfo => 'Grátis e leve. Abre Pacotes de conteúdo.';

  @override
  String get skillsTrains => 'Trabalha';

  @override
  String get skillsTips => 'Dicas e truques';

  @override
  String get skillsWorkouts => 'Exercícios guiados';

  @override
  String get skillsSafety =>
      'Só prática individual: bases, trabalho de pés, sombra e condicionamento. Aprenda combate, trabalho em dupla e armas com um professor qualificado.';

  @override
  String get kindStance => 'Bases';

  @override
  String get kindTechnique => 'Técnicas';

  @override
  String get kindDrill => 'Exercícios';

  @override
  String get kindConditioning => 'Condicionamento';

  @override
  String get searchEmpty =>
      'Pesquise todos os exercícios, técnicas de artes marciais, dicas e treinos.';

  @override
  String searchNoResults(String query) {
    return 'Nada encontrado para \"$query\".';
  }

  @override
  String get searchSkills => 'Artes marciais';

  @override
  String get searchExercises => 'Exercícios e técnicas';

  @override
  String get searchWorkouts => 'Treinos';

  @override
  String get searchTips => 'Dicas e truques';

  @override
  String searchMore(int count) {
    return 'Mais $count: refine a sua pesquisa';
  }

  @override
  String get searchClear => 'Limpar';

  @override
  String get featureStyleDna => 'DNA de estilo';

  @override
  String get featureGetReady => 'Prepare-se para…';

  @override
  String get featureOutfitCalendar => 'Calendário de looks';

  @override
  String get featureWardrobeStats => 'Estatísticas do guarda-roupa';

  @override
  String get featureGlasses => 'Localizador de óculos';

  @override
  String get dnaSaved => 'DNA de estilo salvo';

  @override
  String get dnaYour => 'O seu DNA de estilo';

  @override
  String get dnaEmpty =>
      'Escolha abaixo o que tem a ver com você. Todas as sugestões do app seguem isto.';

  @override
  String get dnaPaletteDone => 'As suas cores';

  @override
  String get dnaFindPalette => 'Descubra as suas cores';

  @override
  String get dnaFindShape => 'Descubra o formato do rosto';

  @override
  String get dnaStyles => 'Estilos de que gosta';

  @override
  String get dnaStylesHelp => 'Escolha quantos quiser.';

  @override
  String get dnaFits => 'Como gosta que a roupa assente';

  @override
  String get dnaFitsHelp =>
      'Usado para dicas de looks e lacunas do guarda-roupa.';

  @override
  String get dnaOccasions => 'Para o que mais se veste';

  @override
  String get dnaOccasionsHelp =>
      'Orienta as lacunas do guarda-roupa e o calendário de looks.';

  @override
  String get dnaCultural => 'Roupa cultural e tradicional';

  @override
  String get dnaCulturalHelp =>
      'Para que as ideias de festas e casamentos combinem com as suas tradições.';

  @override
  String get dnaModesty => 'Cobertura que prefere';

  @override
  String get dnaModestyHelp => 'Todas as ideias de looks respeitam isto.';

  @override
  String get dnaBudget => 'Orçamento';

  @override
  String get dnaBudgetHelp =>
      'Só para lacunas e ideias de compra. Nunca é compartilhado.';

  @override
  String get fitPrefSlim => 'Justo';

  @override
  String get fitPrefRegular => 'Regular';

  @override
  String get fitPrefRelaxed => 'Folgado';

  @override
  String get fitPrefOversized => 'Oversized';

  @override
  String get fitPrefTailored => 'Sob medida';

  @override
  String get culturalIndianEthnic => 'Étnico indiano';

  @override
  String get culturalModest => 'Moda modesta';

  @override
  String get culturalWestern => 'Ocidental';

  @override
  String get culturalFusion => 'Fusão indo-ocidental';

  @override
  String get modestyRelaxed => 'Livre';

  @override
  String get modestyModerate => 'Moderada';

  @override
  String get modestyCovered => 'Totalmente coberta';

  @override
  String get budgetValue => 'Econômico';

  @override
  String get budgetMidRange => 'Intermediário';

  @override
  String get budgetPremium => 'Premium';

  @override
  String get readyIntro =>
      'Escolha para o que está se preparando. Terá uma só lista: look, cuidados pessoais e como se apresentar.';

  @override
  String readyProgress(int done, int total) {
    return '$done de $total prontos';
  }

  @override
  String get readyOpen => 'Abrir';

  @override
  String get readyEvInterview => 'Entrevista';

  @override
  String get readyEvPresentation => 'Apresentação';

  @override
  String get readyEvOffice => 'Dia de escritório';

  @override
  String get readyEvDate => 'Encontro';

  @override
  String get readyEvWedding => 'Casamento';

  @override
  String get readyEvFestival => 'Festividade';

  @override
  String get readyEvParty => 'Festa';

  @override
  String get readyEvCasual => 'Passeio';

  @override
  String get readyEvGym => 'Academia';

  @override
  String get readyEvTravel => 'Viagem';

  @override
  String get readySecOutfit => 'Look';

  @override
  String get readySecGrooming => 'Cuidados pessoais';

  @override
  String get readySecPresentation => 'Postura, respiração e voz';

  @override
  String get readySecFinalChecks => 'Antes de sair';

  @override
  String get readyPlanned => 'Use o look que planejou para hoje';

  @override
  String get readySuggested => 'Use isto do seu guarda-roupa';

  @override
  String get readyGuideInterview =>
      'Arrumado e sóbrio: camisa ou blusa passada, calça ou saia social, sapatos fechados';

  @override
  String get readyGuidePresentation =>
      'Uma camada arrumada em que se mova à vontade, em uma ou duas cores calmas';

  @override
  String get readyGuideOffice =>
      'Esporte fino: gola ou blusa alinhada, calça que assente bem, sapatos limpos';

  @override
  String get readyGuideDate =>
      'Algo em que se sinta confiante, um pouco mais arrumado que o dia a dia';

  @override
  String get readyGuideWedding =>
      'Festivo e elegante: cores ricas ou roupa tradicional, sapatos engraxados';

  @override
  String get readyGuideFestival =>
      'Vivo ou tradicional, confortável para um dia longo';

  @override
  String get readyGuideParty => 'Uma peça de destaque com básicos simples';

  @override
  String get readyGuideCasual => 'Confortável e alinhado para o clima';

  @override
  String get readyGuideGym =>
      'Roupa de treino respirável e tênis com bom apoio';

  @override
  String get readyGuideTravel => 'Camadas confortáveis e sapatos práticos';

  @override
  String get readyGuideEthnic =>
      'Roupa tradicional: kurta, sári, sherwani ou lehenga em cores festivas';

  @override
  String get readyModest => 'Escolha peças de cobertura total, como prefere';

  @override
  String get readyFitSlim => 'Opte por um corte justo e limpo';

  @override
  String get readyFitRegular => 'Opte por um corte regular e confortável';

  @override
  String get readyFitRelaxed => 'Folgado, mas bem ajustado nos ombros';

  @override
  String get readyFitOversized => 'Equilibre peças oversized com uma justa';

  @override
  String get readyFitTailored => 'Peças sob medida: confira mangas e barras';

  @override
  String get readyColours => 'Use as suas melhores cores perto do rosto';

  @override
  String get readyPress => 'Passe ou vaporize o look';

  @override
  String get readyShoes => 'Limpe ou engraxe os sapatos';

  @override
  String get readyLayer => 'Leve uma camada para o clima';

  @override
  String readyHairStyle(String style) {
    return 'Cabelo: $style combina com o formato do seu rosto';
  }

  @override
  String get readyHairTidy => 'Penteie ou arrume o cabelo';

  @override
  String readyBeardStyle(String style) {
    return 'Barba: modele como $style';
  }

  @override
  String get readyBeardTidy => 'Apare ou barbeie; limpe a linha do pescoço';

  @override
  String get readySkin => 'Limpe e hidrate';

  @override
  String get readySunscreen => 'Protetor solar para o tempo ao ar livre';

  @override
  String get readyNails => 'Unhas limpas e aparadas';

  @override
  String get readyScentLight => 'Uma fragrância leve, ou nenhuma';

  @override
  String get readyGymHair => 'Prenda o cabelo; leve uma toalha';

  @override
  String get readyPosture =>
      'Fique ereto: ombros para trás e para baixo, queixo nivelado';

  @override
  String get readyBreath =>
      'Respire devagar por um minuto: inspire 4, expire 6';

  @override
  String get readyFaceWarmup => 'Aqueça o rosto e a voz por dois minutos';

  @override
  String get readyVoice =>
      'Fale um pouco mais devagar do que parece natural, e faça pausas';

  @override
  String get readyEyeContact =>
      'Contato visual amigável, depois desvie o olhar brevemente';

  @override
  String get readyThreePoints => 'Saiba de cor os seus três pontos principais';

  @override
  String get readyDocuments => 'Cópias de documentos ou slides, e uma caneta';

  @override
  String get readyTravelDocs => 'Documento, passagens, carregadores e remédios';

  @override
  String get readyGymKit => 'Água, toalha, tênis e uma muda de roupa';

  @override
  String get readyGift => 'O presente ou o shagun';

  @override
  String get readyWater => 'Uma garrafa de água';

  @override
  String get readyPhone => 'Celular carregado, chaves e carteira';

  @override
  String get readyEarly => 'Saia cedo para chegar com calma';

  @override
  String get calendarEarlier => 'Antes';

  @override
  String get calendarLater => 'Depois';

  @override
  String get calendarNoOutfits =>
      'Salve alguns looks primeiro e depois planeje-os aqui.';

  @override
  String get calendarToday => 'Hoje';

  @override
  String get calendarPlan => 'Planejar';

  @override
  String get calendarWorn => 'Usado';

  @override
  String get calendarWoreIt => 'Usei';

  @override
  String get calendarRemove => 'Remover';

  @override
  String get calendarPickTitle => 'Escolha um look';

  @override
  String get calendarNoneForOccasion =>
      'Ainda sem looks salvos para esta ocasião.';

  @override
  String statsPriceTitle(String name) {
    return 'Quanto custou $name?';
  }

  @override
  String get statsPrice => 'Preço';

  @override
  String get statsPriceHelp =>
      'Opcional. Fica neste celular; deixe vazio para apagar.';

  @override
  String statsWears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'usado $count vezes',
      one: 'usado uma vez',
      zero: 'ainda não usado',
    );
    return '$_temp0';
  }

  @override
  String statsLastWorn(String date) {
    return 'último: $date';
  }

  @override
  String get statsAddPrice => 'Adicionar preço';

  @override
  String get statsEmpty =>
      'Adicione roupas ao guarda-roupa e marque looks como usados para ver o que você realmente veste.';

  @override
  String get statsItems => 'peças';

  @override
  String get statsTotalWears => 'usos';

  @override
  String get statsNeutrals => 'básicos neutros';

  @override
  String get statsGaps => 'O que falta';

  @override
  String get statsMostWorn => 'Mais usadas';

  @override
  String get statsBestValue => 'Melhor custo-benefício';

  @override
  String get statsBestValueHelp => 'Menor custo por uso até agora.';

  @override
  String statsPerWear(String price) {
    return '$price por uso';
  }

  @override
  String get statsNeverWorn => 'Ainda não usadas';

  @override
  String get statsNeverWornHelp =>
      'Experimente uma destas esta semana, ou passe-a adiante.';

  @override
  String get gapBottoms => 'Partes de baixo';

  @override
  String get gapAdviceBottoms =>
      'Adicione calças, jeans ou uma saia para que as partes de cima virem looks.';

  @override
  String get gapFootwear => 'Calçados';

  @override
  String get gapAdviceFootwear =>
      'Um par versátil (tênis branco ou mocassim liso) completa a maioria dos looks.';

  @override
  String get gapWorkTop => 'Uma peça para o trabalho';

  @override
  String get gapAdviceWorkTop =>
      'Uma camisa ou blusa lisa em branco, azul-claro ou um neutro suave.';

  @override
  String get gapFormalWear => 'Algo formal';

  @override
  String get gapAdviceFormalWear =>
      'Um blazer, terno ou vestido formal para dias importantes.';

  @override
  String get gapFestiveEthnic => 'Roupa festiva ou tradicional';

  @override
  String get gapAdviceFestiveEthnic =>
      'Uma kurta, sári ou conjunto étnico numa cor da sua paleta.';

  @override
  String get gapNeutralBasics => 'Básicos neutros';

  @override
  String get gapAdviceNeutralBasics =>
      'Adicione duas peças neutras (azul-marinho, bege, cinza, branco) para combinar facilmente as coloridas.';

  @override
  String get gapSportwear => 'Roupa de treino';

  @override
  String get gapAdviceSportwear =>
      'Camisetas respiráveis e shorts ou leggings para exercício.';

  @override
  String get gapOuterwear => 'Uma jaqueta ou camada';

  @override
  String get gapAdviceOuterwear =>
      'Uma jaqueta ou cardigã para dias mais frescos.';

  @override
  String get glassesSizeTip =>
      'O tamanho importa tanto quanto o formato: a armação deve ter mais ou menos a largura do rosto nas têmporas, com os olhos perto do centro de cada lente.';

  @override
  String get glassesTryOn => 'Experimentar ao vivo';

  @override
  String get glassesNoShape =>
      'Analise o formato do rosto para recomendações pessoais';

  @override
  String glassesForShape(String shape) {
    return 'Ordenadas para o seu rosto $shape';
  }

  @override
  String get glassesHonest =>
      'Orientação baseada em regras de contraste, não um julgamento da aparência. Use o que gosta.';

  @override
  String get fitGreat => 'Ótima escolha';

  @override
  String get fitGood => 'Boa escolha';

  @override
  String get fitLess => 'Equilibra menos';

  @override
  String get fitReasonAddsAngles =>
      'Linhas angulares dão definição a traços mais suaves e arredondados.';

  @override
  String get fitReasonSoftensAngles =>
      'Armações curvas suavizam um maxilar e uma testa marcados.';

  @override
  String get fitReasonAddsLength =>
      'Armações mais altas quebram o comprimento e acrescentam largura.';

  @override
  String get fitReasonBalancesForehead =>
      'Armações leves ou mais pesadas embaixo equilibram uma testa larga.';

  @override
  String get fitReasonLiftsCheekbones =>
      'Armações ovais ou levantadas destacam as maçãs do rosto.';

  @override
  String get fitReasonSuitsMost =>
      'Proporções equilibradas combinam com a maioria das armações; escolha a que gostar.';

  @override
  String get fitReasonEchoesShape =>
      'Este formato repete as linhas do seu rosto, por isso equilibra menos. A escolha continua sendo sua.';

  @override
  String get fitReasonUnknownShape =>
      'Analise o rosto para ver como esta armação equilibra o seu formato.';

  @override
  String get whyFeedBodyPlan =>
      'Você ainda não configurou um plano de dieta e corpo.';

  @override
  String get benefitFeedBodyPlan =>
      'Um plano transforma o seu objetivo em calorias, refeições e treino diários adequados à sua região.';

  @override
  String get whyFeedGoals =>
      'Os seus objetivos definem quais missões, dicas e áreas você vê primeiro.';

  @override
  String get benefitFeedGoals =>
      'Escolher um foco mantém o app no que importa para você.';

  @override
  String get whyFeedSnapshot => 'Ainda não há foto de progresso esta semana.';

  @override
  String get benefitFeedSnapshot =>
      'Uma foto semanal mostra mudanças reais que o espelho não vê.';

  @override
  String get whyFeedFace => 'O formato do seu rosto ainda não foi analisado.';

  @override
  String get benefitFeedFace =>
      'Adapta a você as ideias de cabelo, barba e óculos.';

  @override
  String get whyFeedHairstyles => 'Estas seguem o formato do seu rosto.';

  @override
  String get benefitFeedHairstyles =>
      'Estilos que equilibram os seus traços, com o motivo de cada um.';

  @override
  String get whyFeedTryOn =>
      'Pode ver óculos e barbas ao vivo antes de mudar alguma coisa.';

  @override
  String get benefitFeedTryOn =>
      'Veja no seu próprio rosto, em privado, neste celular.';

  @override
  String get whyFeedColours => 'A sua paleta de cores ainda não foi definida.';

  @override
  String get benefitFeedColours =>
      'Conhecer as suas cores facilita looks e compras.';

  @override
  String get whyFeedOutfit =>
      'Você tem roupas suficientes para ideias de looks.';

  @override
  String get benefitFeedOutfit =>
      'Ideias com o que você já tem, com os motivos.';

  @override
  String get whyFeedPosture =>
      'Uma avaliação rápida de postura é útil a cada uma ou duas semanas.';

  @override
  String get benefitFeedPosture =>
      'Perceba cedo a tensão no pescoço e nas costas, com exercícios que ajudam.';

  @override
  String get whyFeedExercise =>
      'Mexer-se quase todos os dias ajuda todos os outros objetivos.';

  @override
  String get benefitFeedExercise =>
      'Treinos guiados e mais de 1.500 exercícios, muitos sem equipamento.';

  @override
  String get onboardingGoalsTitle => 'No que gostaria de trabalhar?';

  @override
  String get onboardingGoalsBody =>
      'Escolha os que importam para você. Só perguntaremos o que estes objetivos precisam, e pode mudá-los quando quiser.';

  @override
  String get onboardingAboutFocused =>
      'Só o que os seus objetivos precisam. Pode adicionar o resto depois no Perfil.';

  @override
  String get settingsTimeFormat => 'Formato de hora';

  @override
  String get timeFormatDevice => 'Igual ao aparelho';

  @override
  String get timeFormat12 => '12 horas';

  @override
  String get timeFormat24 => '24 horas';

  @override
  String get settingsSecurity => 'Segurança';

  @override
  String get actionOk => 'OK';

  @override
  String get lockTitle => 'Bloqueio do app';

  @override
  String get lockSubtitle => 'Pedir PIN ou digital ao abrir o app';

  @override
  String get lockEnterPin => 'Digite o seu PIN';

  @override
  String get lockSetPin => 'Escolha um PIN';

  @override
  String get lockConfirmPin => 'Digite o PIN de novo';

  @override
  String get lockPinRules =>
      'De 4 a 8 dígitos. Se esquecer, o app não abre sem apagar os dados, então escolha um de que se lembre.';

  @override
  String get lockPinMismatch => 'Os PINs não coincidem. Tente de novo.';

  @override
  String get lockWrongPin => 'PIN incorreto';

  @override
  String lockWait(int seconds) {
    return 'Tentativas demais. Aguarde $seconds s.';
  }

  @override
  String get lockUseFingerprint => 'Desbloquear com digital';

  @override
  String get lockBiometricReason => 'Desbloquear o Personality';

  @override
  String get lockForgot => 'Esqueceu o PIN?';

  @override
  String get lockForgotInfo =>
      'Para a sua privacidade, o PIN não pode ser redefinido nem recuperado, nem por nós. Se o desbloqueio por digital estiver ativo, use-o e depois mude o PIN em Configurações. Caso contrário, apagar os dados do app (Configurações do Android → Apps) remove o bloqueio e tudo o que está no app; depois restaure um backup.';

  @override
  String get lockOn => 'O bloqueio está ativado';

  @override
  String get lockOff => 'O bloqueio está desativado';

  @override
  String get lockChangePin => 'Mudar PIN';

  @override
  String get lockChanged => 'PIN alterado';

  @override
  String get lockDelete => 'Apagar';

  @override
  String lockDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dígitos digitados',
      one: '1 dígito digitado',
      zero: 'Nenhum dígito digitado',
    );
    return '$_temp0';
  }

  @override
  String get widgetNext => 'Próximo';

  @override
  String get widgetAddGlass => '+ Copo';

  @override
  String get widgetLocked => 'Desbloqueie o app para ver a próxima tarefa';

  @override
  String get widgetNothingNext => 'Nada planejado agora';

  @override
  String get contactTitle => 'Contato e suporte';

  @override
  String get contactBody =>
      'Dúvidas, ideias ou algum problema? Escreva para nós.';

  @override
  String aboutMadeBy(String company) {
    return 'Feito por $company';
  }

  @override
  String get contactEmailCopied => 'Endereço de e-mail copiado';

  @override
  String get contactEmailSubject => 'App Personality';

  @override
  String get lockMethodTitle => 'Como quer desbloquear?';

  @override
  String get lockMethodDevice => 'Bloqueio de tela do celular';

  @override
  String get lockMethodDeviceInfo =>
      'Digital, rosto, ou o PIN, padrão ou senha do seu celular. Nada novo para lembrar. Recomendado.';

  @override
  String get lockMethodPin => 'PIN do app';

  @override
  String get lockMethodPinInfo =>
      'Um PIN separado de 4 a 8 dígitos só para este app.';

  @override
  String get lockUsesDevice =>
      'Desbloqueia com o bloqueio de tela do seu celular';

  @override
  String get lockUsesPin => 'Desbloqueia com um PIN do app';

  @override
  String get lockSwitchToDevice => 'Usar o bloqueio de tela do celular';

  @override
  String get lockSwitchToPin => 'Usar um PIN do app';

  @override
  String get lockUnlock => 'Desbloquear';

  @override
  String get lockDeviceHint =>
      'Use a digital, o rosto, ou o PIN, padrão ou senha do celular.';

  @override
  String get lockDeviceFailed => 'Não desbloqueado. Tente de novo.';

  @override
  String get lockNoDeviceLock =>
      'Este celular não tem bloqueio de tela. Defina um nas configurações do Android ou use um PIN do app.';

  @override
  String get lockDeviceRemoved =>
      'O seu celular já não tem bloqueio de tela, por isso o bloqueio do app foi desativado.';

  @override
  String get weightJourneyTitle => 'A sua jornada de peso';

  @override
  String get weightJourneyNoGoal =>
      'Defina uma meta para traçar a sua jornada.';

  @override
  String get weightJourneySetGoal => 'Definir meta';

  @override
  String get weightJourneyMaintain =>
      'Você começou dentro da sua faixa-alvo, por isso esta jornada é sobre se manter nela.';

  @override
  String weightJourneyProgress(int percent) {
    return '$percent% do caminho';
  }

  @override
  String get weightJourneyReached => 'Meta atingida';

  @override
  String get weightJourneyTapHint => 'Toque numa bandeira para ver o peso.';

  @override
  String weightMilestoneAt(int percent, String weight) {
    return 'Marca de $percent%: $weight';
  }

  @override
  String weightJourneySemantics(int percent, String start, String target) {
    return 'Jornada de peso: $percent% do caminho de $start até $target';
  }

  @override
  String get weightStatWeek => 'Esta semana';

  @override
  String get weightStatSinceStart => 'Desde o início';

  @override
  String get weightStatToGo => 'Falta';

  @override
  String get weightStatStreak => 'Sequência de pesagens';

  @override
  String weightStreakWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
      zero: 'Ainda não',
    );
    return '$_temp0';
  }

  @override
  String get weightLogTitle => 'Suba na balança';

  @override
  String get weightLogHint =>
      'Arraste a régua, ou use − e +, para definir o seu peso.';

  @override
  String get weightLogSave => 'Salvar pesagem';

  @override
  String get weightLogSaved => 'Pesagem salva';

  @override
  String get weightDecrease => 'Menos';

  @override
  String get weightIncrease => 'Mais';

  @override
  String weightCelebrateMilestone(int percent) {
    return '$percent% do caminho!';
  }

  @override
  String weightCelebrateBody(String weight) {
    return 'Agora com $weight. Passos constantes somam. Continue no seu ritmo.';
  }

  @override
  String get weightCelebrateGoal => 'Você atingiu a sua meta!';

  @override
  String get weightCelebrateGoalBody =>
      'Agora a jornada é mantê-la. A sua tendência mostrará como se sustenta.';

  @override
  String get weightCelebrateOk => 'Continuar';

  @override
  String get featureGoalReminders => 'Lembretes de metas';

  @override
  String get goalRemindersIntro =>
      'Lembretes suaves para as suas metas. Cada um é uma rotina, então horário silencioso, Feito e Adiar funcionam, e nada sai do seu celular.';

  @override
  String get goalRemindForYou => 'Sua meta';

  @override
  String get goalRemindWeighIn => 'Pesagem';

  @override
  String get goalRemindWeighInItem => 'Hora da pesagem: suba na balança';

  @override
  String get goalRemindWeighInInfo =>
      'Mesmo dia e hora, antes do café da manhã: a forma mais justa de ver a sua tendência.';

  @override
  String get goalRemindWater => 'Beber água';

  @override
  String get goalRemindWaterItem => 'Hora de um copo de água';

  @override
  String get goalRemindWaterInfo =>
      'Distribuídos ao longo do dia para a meta de água vir com facilidade.';

  @override
  String get goalRemindBedtime => 'Desacelerar para dormir';

  @override
  String get goalRemindBedtimeItem => 'Comece a desacelerar para dormir';

  @override
  String get goalRemindBedtimeInfo =>
      'Um lembrete para baixar as telas e se preparar para dormir num horário regular.';

  @override
  String get goalRemindMove => 'Pausa para se mexer';

  @override
  String get goalRemindMoveItem => 'Levante-se e mexa-se por 5 minutos';

  @override
  String get goalRemindMoveInfo =>
      'Caminhadas curtas quebram longos períodos sentado nos dias úteis.';

  @override
  String get goalRemindPosture => 'Pausa para a postura';

  @override
  String get goalRemindPostureItem =>
      'Pausa para a postura: gire os ombros e sente-se ereto';

  @override
  String get goalRemindPostureInfo =>
      'Uma pausa rápida para pescoço e costas durante o dia de trabalho.';

  @override
  String get goalRemindDays => 'Dias';

  @override
  String get goalRemindTimes => 'Horários';

  @override
  String get goalRemindAddTime => 'Adicionar horário';

  @override
  String goalRemindRemoveTime(String time) {
    return 'Remover $time';
  }

  @override
  String get goalRemindWeekdays => 'Dias úteis';
}
