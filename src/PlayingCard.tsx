import { useState, useEffect } from "react";

interface Card {
  image: string;
  code: string;
  value: string;
  suit: string;
}

interface Props {
  deckId: string;
}

const PlayingCard: React.FC<Props> = ({ deckId }) => {
  const [card, setCard] = useState<Card | null>(null);

  useEffect(() => {
    async function fetchPlayingCard() {
      try {
        const response = await fetch(
          `https://deckofcardsapi.com/api/deck/${deckId}/draw/?count=1`
        );
        const data = await response.json();
        setCard({
          image: data.cards[0].image,
          code: data.cards[0].code,
          value: data.cards[0].value,
          suit: data.cards[0].suit,
        } as Card);
      } catch (e) {
        console.error(e);
      }
    }
    fetchPlayingCard();
  }, [deckId]);

  return (
    <div>
      <h2>
        The {card?.value} of {card?.suit}
      </h2>
      <img
        src={card?.image}
        alt={`An image of the ${card?.value} of ${card?.suit}`}
      />
    </div>
  );
};

export default PlayingCard;
