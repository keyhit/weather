module AccuweatherExamples
  CITY_EXAMPLE = { 'Version' => 1,
                   'Key' => '1-324505_1_AL',
                   'LocalizedName' => 'Kiev',
                   'EnglishName' => 'Kyiv' }
  FORECAST_EXAMPLES = { 'Date' => '2017-11-19T07:00:00+02:00',
                        'Day' => { 'PrecipitationProbability'=>65 },
                        'Temperature' => { 
                          'Minimum' => { 'Value' =>-1.9, 'Unit' =>'C', 'UnitType' =>17 }, 
                          'Maximum' => { 'Value' =>4.1, 'Unit' =>'C', 'UnitType' =>17 } 
                      } }
end
