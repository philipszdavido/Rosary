//
//  prayerData.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation

class PrayerData {
    
    static let prayers = [
        Prayer(name: "Rosary", type: PrayerEnum.rosary, data: ""),
        Prayer(
            name: "Our Father",
            type: PrayerEnum.single,
            data: PrayerData.ourFather
        ),
        Prayer(
            name: "Hail Mary",
            type: PrayerEnum.single,
            data: PrayerData.hailMary
        ),
        Prayer(
            name: "Prayer to St. Joseph",
            type: PrayerEnum.single,
            data: PrayerData.joseph
        ),
        Prayer(
            name: "St. Francis De Asisi",
            type: PrayerEnum.single,
            data: PrayerData.stFrancisAsisiPrayer
        ),
        Prayer(
            name: "Memorare",
            type: PrayerEnum.single,
            data: PrayerData.memorare
        ),
        Prayer(
            name: "Hail Holy Queen",
            type: PrayerEnum.single,
            data: PrayerData.hailHolyQueen
        ),
        Prayer(
            name: "Act of Contrition",
            type: PrayerEnum.single,
            data: PrayerData
                .actOfContrition)
    ]
    
    static func constructPrayer(_ data: String, name: String, type: PrayerEnum = .single) -> Prayer {
        return Prayer(name: name, type: type, data: data)
    }
    
    static func ourFatherPrayer(_ type: PrayerEnum = .single) -> Prayer {
        return PrayerData
            .constructPrayer(ourFather, name: "Our Father", type: type)
    }
    
    static func hailMaryPrayer(_ type: PrayerEnum = .single) -> Prayer {
        return PrayerData.constructPrayer(hailMary, name: "Hail Mary", type: type)
    }
    
    static func gloryBePrayer(_ type: PrayerEnum = .single) -> Prayer {
        return PrayerData.constructPrayer(gloryBe, name: "Glory Be", type: type)
    }

    static let ourFather = """
    Our Father,
    """

    static let _ourFather = """
    Our Father,
    Who art in heaven,
    hallowed be Thy name.
    Thy kingdom come,
    Thy will be done, on earth as it is in heaven.
    Give us this day our daily bread,
    and forgive us our trespasses
    as we forgive those who trespass against us,
    and lead us not into temptation,
    but deliver us from evil. Amen.
    """

    static let hailMary = """
    Hail Mary
    """
    
    static let _hailMary = """
    Hail Mary, full of grace, the Lord is with thee.
    Blessed art thou amongst women,
    and blessed is the fruit of thy womb, Jesus.
    Holy Mary, Mother of God,
    pray for us sinners,
    now and at the hour of our death. Amen.
    """

    static let gloryBe = """
    Glory
    """
    
    static let _gloryBe = """
    Glory be to the Father,
    and to the Son,
    and to the Holy Spirit,
    as it was in the beginning,
    is now, and ever shall be,
    world without end. Amen.
    """

    static let apostlesCreed = """
    I believe
    """

    static let _apostlesCreed = """
    I believe in God,
    the Father Almighty,
    Creator of Heaven and earth;
    and in Jesus Christ, His only Son, Our Lord,
    Who was conceived by the Holy Spirit,
    born of the Virgin Mary,
    suffered under Pontius Pilate,
    was crucified, died, and was buried.
    He descended into Hell,
    on the third day He arose again from the dead.
    He ascended into Heaven,
    and is seated at the right hand of
    God the Father Almighty;
    from thence He shall come to judge
    the living and the dead.
    I believe in the Holy Spirit,
    the holy Catholic Church,
    the communion of saints,
    the forgiveness of sins,
    the resurrection of the body,
    and the life everlasting. Amen.
    """
    
    static let hailHolyQueen = """
    Hail, Holy Queen, Mother of mercy,
    our life, our sweetness and our hope.
    To thee do we cry,
    poor banished children of Eve:
    to thee do we send up our sighs,
    mourning and weeping in this valley of tears.
    Turn then, most gracious advocate,
    thine eyes of mercy toward us,
    and after this our exile,
    show unto us the blessed
    fruit of thy womb, Jesus.
    O clement, O loving, O sweet Virgin Mary!
    Pray for us, O holy Mother of God,
    that we may be made worthy
    of the promises of Christ. Amen.
    """
    
    static let animaChristi = """
    Soul of Christ, sanctify me,
    Body of Christ, save me,
    Blood of Christ, inebriate me,
    Water from the side of Christ, wash me,
    Passion of Christ, strengthen me,
    O good Jesus, hear me.
    Hide me within your wounds,
    keep me close to you,
    defend me from the evil enemy,
    call me at the hour of my death,
    and bid me to come to you,
    to praise you with your saints,
    forever and ever. Amen.
    """
    
    static let memorare = """
    Remember, O most gracious Virgin Mary,
    that never was it known
    that anyone who fled to thy protection,
    implored thy help,
    or sought thy intercession,
    was left unaided.
    Inspired by this confidence,
    we fly unto thee,
    O Virgin of virgins, my Mother;
    to thee do we come, before thee we stand,
    sinful and sorrowful.
    O Mother of the Word Incarnate,
    despise not our petitions,
    but in thy mercy hear and answer them. Amen.
    """
    
    static let saintMichaelPrayer = """
    Saint Michael the Archangel,
    defend us in battle.
    Be our protection against
    the wickedness and snares of the devil.
    May God rebuke him, we humbly pray,
    and do thou, O Prince of the heavenly host,
    by the power of God,
    cast into hell Satan and all the evil spirits
    who prowl throughout the world
    seeking the ruin of souls. Amen.
    """
    
    static let actOfContrition = """
    O my God, I am heartfully sorry for having offended thee,
    and I detest all my sins because of thy just punishment,
    but most of all because I have offended thee, my God,
    who is all good and deserving of all my love.
    I firmly resolve, with the help of thy grace,
    to sin no more, and to avoid the near occasion of sin. Amen.
    """
    
    static let miraculousMedalPrayer = """
    O Mary, Conceived without Sin,
    pray for us who have recourse to thee,
    and for those who do not have recourse to thee,
    especially the enemies of the Church. Amen.
    """
    
    static let morningOffering = """
    Dear Lord, I do not know what will happen to me today —
    I only know that nothing will happen that was not foreseen by you
    and directed to my greater good from all eternity.
    I adore your holy and unfathomable plans,
    and submit to them with all my heart for love of you,
    the pope, and the Immaculate Heart of Mary. Amen.
    """
    
    static let guardianAngelPrayer = """
    Angel of God, my guardian dear,
    to whom God's love commits me here,
    ever this day be at my side,
    to light and guard, to rule and guide. Amen.
    """
    
    static let prayerOfSurrender = """
    Lord Jesus Christ, take all my freedom,
    my understanding, and my will.
    All that I have and cherish you have given to me.
    I surrender it all to be guided by your will.
    Your love and your grace are wealth enough for me.
    Give me these, Lord Jesus, and I ask for nothing more. Amen.
    """
    
    static let graceBeforeMeals = """
    Bless us, O Lord, and these thy gifts,
    which we are about to receive,
    from thy bounty, through Christ our Lord. Amen.
    """
    
    static let graceAfterMeals = """
    We give thee thanks for all thy benefits,
    O Almighty God, who lives and reigns,
    world without end. Amen.
    """
    
    static let soulsOfFaithfulDeparted = """
    May the souls of the faithful departed,
    through the mercy of God, rest in peace. Amen.
    """

    static let signOfTheCross = """
    In the name
    """

    static let _signOfTheCross = """
    In the name of the Father,
    and of the Son,
    and of the Holy Spirit. Amen.
    """
    
    static let stFrancisAsisiPrayer = """
    Lord, make me a channel of thy peace,
    that where there is hatred, I may bring love;
    that where there is wrong,
    I may bring the spirit of forgiveness;
    that where there is discord, I may bring harmony;
    that where there is error, I may bring truth;
    that where there is doubt, I may bring faith;
    that where there is despair, I may bring hope;
    that where there are shadows, I may bring light;
    that where there is sadness, I may bring joy.
    Lord, grant that I may seek rather to
    comfort than to be comforted;
    to understand, than to be understood;
    to love, than to be loved.
    For it is by self-forgetting that one finds.
    It is by forgiving that one is forgiven.
    It is by dying that one awakens to Eternal Life.
    """
    
    static let joseph = """
    To you, O blessed Joseph,
    do we come in our tribulation,
    and having implored the help of your most holy Spouse,
    we confidently invoke your patronage also.

    Through that charity which bound you
    to the Immaculate Virgin Mother of God
    and through the paternal love
    with which you embraced the Child Jesus,
    we humbly beg you graciously to regard the inheritance
    which Jesus Christ has purchased by his Blood,
    and with your power and strength to aid us in our necessities.

    O most watchful guardian of the Holy Family,
    defend the chosen children of Jesus Christ;
    O most loving father, ward off from us
    every contagion of error and corrupting influence;
    O our most mighty protector, be kind to us
    and from heaven assist us in our struggle
    with the power of darkness.

    As once you rescued the Child Jesus from deadly peril,
    so now protect God's Holy Church
    from the snares of the enemy and from all adversity;
    shield, too, each one of us by your constant protection,
    so that, supported by your example and your aid,
    we may be able to live piously, to die in holiness,
    and to obtain eternal happiness in heaven.

    Amen.
    """
    
    static let fatima = """
    O my Jesus, forgive us our sins, save us from the fires of hell, lead all souls to Heaven, especially those in most need of your mercy.
    """
    
}
