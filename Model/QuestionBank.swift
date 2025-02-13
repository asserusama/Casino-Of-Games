import Foundation

struct QuestionBank {
    public var questions: [QuestionType: [Question]] = [:]

    init() {
        loadQuestions()
    }

    public mutating func loadQuestions() {
        questions[.reversedWords] = [
            Question(type: .reversedWords, question: "اكراب", correctAnswer: "بارك", options: nil),
            Question(type: .reversedWords, question: "ةفرسأ", correctAnswer: "أسرفة", options: nil),
            Question(type: .reversedWords, question: "نعور", correctAnswer: "ورع", options: nil),
            Question(type: .reversedWords, question: "دوراج", correctAnswer: "جارد", options: nil),
            Question(type: .reversedWords, question: "مهدارا", correctAnswer: "أرهدم", options: nil)
        ]

        questions[.capitals] = [
            Question(type: .capitals, question: "ما عاصمة مصر؟", correctAnswer: "القاهرة", options: nil),
            Question(type: .capitals, question: "ما عاصمة المملكة العربية السعودية؟", correctAnswer: "الرياض", options: nil),
            Question(type: .capitals, question: "ما عاصمة فرنسا؟", correctAnswer: "باريس", options: nil),
            Question(type: .capitals, question: "ما عاصمة أمريكا؟", correctAnswer: "واشنطن دي سي", options: nil),
            Question(type: .capitals, question: "ما عاصمة الإمارات العربية المتحدة؟", correctAnswer: "أبوظبي", options: nil)
        ]

        questions[.songWord] = [
            Question(type: .songWord, question: "ضع كلمة 'حب' في أغنية مشهورة", correctAnswer: "أنت الحب", options: nil),
            Question(type: .songWord, question: "ضع كلمة 'عشق' في أغنية مشهورة", correctAnswer: "عشق الممنوع", options: nil),
            Question(type: .songWord, question: "ضع كلمة 'ليل' في أغنية مشهورة", correctAnswer: "في ليلك", options: nil),
            Question(type: .songWord, question: "ضع كلمة 'أمل' في أغنية مشهورة", correctAnswer: "أمل حياتي", options: nil),
            Question(type: .songWord, question: "ضع كلمة 'أيام' في أغنية مشهورة", correctAnswer: "أيام وليالي", options: nil)
        ]

        questions[.movieScene] = [
            Question(type: .movieScene, question: "مشهد زعيم العصابة يسأل 'إنت فاكر نفسك مين؟'", correctAnswer: "فيلم الكيف", options: nil),
            Question(type: .movieScene, question: "مشهد في فيلم 'أنت جبت الهوا'", correctAnswer: "فيلم أحمد حلمي", options: nil),
            Question(type: .movieScene, question: "مشهد 'إحنا في بلد بلح' في فيلم 'سلام يا صاحبي'", correctAnswer: "فيلم سلام يا صاحبي", options: nil),
            Question(type: .movieScene, question: "مشهد 'أنا عايز أروح عند ماما' في فيلم 'عسل أسود'", correctAnswer: "فيلم عسل أسود", options: nil),
            Question(type: .movieScene, question: "مشهد في فيلم 'إنت فاكر نفسك مين؟'", correctAnswer: "فيلم الكيف", options: nil)
        ]

        questions[.actorCatchphrase] = [
            Question(type: .actorCatchphrase, question: "مين قال 'أنت عارف أنا مين؟'", correctAnswer: "عادل إمام", options: nil),
            Question(type: .actorCatchphrase, question: "مين قال 'أنا مش حابب الكلام ده؟'", correctAnswer: "أحمد زكي", options: nil),
            Question(type: .actorCatchphrase, question: "مين قال 'خلي بالك من نفسك؟'", correctAnswer: "فؤاد المهندس", options: nil),
            Question(type: .actorCatchphrase, question: "مين قال 'مش ممكن!'", correctAnswer: "شويكار", options: nil),
            Question(type: .actorCatchphrase, question: "مين قال 'مفيش فايدة!'", correctAnswer: "محمود عبد العزيز", options: nil)
        ]

        questions[.randomQuestion] = [
            Question(type: .randomQuestion, question: "من هو صاحب كتاب 'الأدب والفن'؟", correctAnswer: "طه حسين", options: nil),
            Question(type: .randomQuestion, question: "ما هو العلم الذي يدرس النجوم؟", correctAnswer: "الفلك", options: nil),
            Question(type: .randomQuestion, question: "من هو أول رئيس جمهورية مصر بعد ثورة 1952؟", correctAnswer: "جمال عبد الناصر", options: nil),
            Question(type: .randomQuestion, question: "ما هو أطول نهر في العالم؟", correctAnswer: "النيل", options: nil),
            Question(type: .randomQuestion, question: "من هو مؤسس الدولة الأموية؟", correctAnswer: "مروان بن الحكم", options: nil),
            Question(type: .randomQuestion, question: "ما هو الغاز الذي يتنفسه البشر؟", correctAnswer: "الأوكسجين", options: nil),
            Question(type: .randomQuestion, question: "أين تقع مدينة هيروشيما؟", correctAnswer: "اليابان", options: nil),
            Question(type: .randomQuestion, question: "ما هي عاصمة إيطاليا؟", correctAnswer: "روما", options: nil),
            Question(type: .randomQuestion, question: "من هو أول إنسان صعد إلى القمر؟", correctAnswer: "نيل آرمسترونغ", options: nil),
            Question(type: .randomQuestion, question: "من هو مؤلف رواية 'الأيام'؟", correctAnswer: "طه حسين", options: nil)
        ]
    }
}
