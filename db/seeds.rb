images = %w(
  https://az810747.vo.msecnd.net/eventcover/2016/03/07/9CF13C.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/05/E62FDF.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/15/67F860.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/01/15/190760.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/22/8BD0FF.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/24/79864E.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/15/6D456B.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/23/768514.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/15/D1E42B.jpg
  https://az810747.vo.msecnd.net/eventcover/2016/03/16/83514D.jpg
)

# Category
cats = ['Âm nhạc', 'Cộng đồng', 'Hội thảo', 'Khóa học', 'Vui chơi & giải trí']
cats.each do |name|
  Category.create(name: name)
end

# Region
regions = ['Ho Chi Minh', 'Ha Noi', 'Da Nang']
regions.each do |name|
  Region.create(name: name)
end

# Venue
20.times do
  Venue.create(
      region: Region.order("RANDOM()").first,
      name: FFaker::Lorem.words(2),
      address: FFaker::AddressUS.city
  )
end

images.each do |img|
  Event.create(
      start_at: Time.zone.local(2016, 7, rand(20) + 1),
      end_at: Time.zone.local(2016, 8, rand(20) + 1),
      description: FFaker::Lorem.paragraph(10),
      name: FFaker::Name.name,
      image: img,
      category: Category.order("RANDOM()").first,
      venue: Venue.order("RANDOM()").first
  )

  # Past events
  Event.create(
      start_at: Time.zone.local(2015, 3, rand(20) + 1),
      end_at: Time.zone.local(2015, 4, rand(20) + 1),
      description: FFaker::Lorem.paragraph(10),
      name: FFaker::Name.name,
      image: img,
      category: Category.order("RANDOM()").first,
      venue: Venue.order("RANDOM()").first
  )
end